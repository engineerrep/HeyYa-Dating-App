import 'dart:async';

import 'package:get/get.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/widget/heyya_assets_picker_builder.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import 'package:heyya/app/flavors/build_config.dart';
import 'package:heyya/app/modules/video/models/video_preview_model.dart';
import 'package:heyya/app/modules/video_topic/controllers/video_topic_controller.dart';
import 'package:heyya/app/routes/app_pages.dart';
import 'package:logger/logger.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class VideoTopicRecordController extends GetxController {
  CameraController? cameraVc;
  Rx<bool> cameraInitialized = false.obs;
  Rx<bool> isRecording = false.obs;
  Rx<int> duration = 0.obs;
  Logger _logger = BuildConfig.instance.config.logger;
  Rx<bool> shouldShowShortTip = false.obs;
  final maxTime = 20;
  Timer? timer;
  bool isFrontCamera = true;

  List<VideoTopicItem> selectedItems = <VideoTopicItem>[];

  String selectedItemsToDisplay() {
    return selectedItems.map((e) {
          final title = e.title;
          return "#$title";
        }).join("  ") +
        "\n";
  }

  @override
  void onInit() {
    super.onInit();
    selectedItems = Get.arguments;
    initFrontCamera();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    if (cameraVc != null) {
      cameraVc?.dispose();
      cameraVc = null;
    }
    if (timer != null) {
      timer?.cancel();
      timer = null;
    }
  }

  startRecordVideo() {
    if (cameraVc!.value.isRecordingVideo) {
      stopRecordVideo();
      return;
    }
    if (cameraVc == null) {
      HeySnackBar.showInfo(
          'The camera is being initialized, try again later...');
      return;
    }
    cameraVc!.startVideoRecording();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print("object: ${duration.value + 1}");
      duration.value = duration.value + 1;
      if (duration.value == maxTime) {
        stopRecordVideo();
      }
    });
  }

  showShortTip() {
    if (shouldShowShortTip.value) {
      return;
    }
    shouldShowShortTip.value = true;
    Future.delayed(Duration(seconds: 2), () {
      shouldShowShortTip.value = false;
    });
  }

  stopRecordVideo() {
    if (duration.value < 5) {
      showShortTip();
      return;
    }
    isRecording.value = false;
    timer?.cancel();
    Future.delayed(Duration(seconds: 2), () {
      duration.value = 0;
    });
    cameraVc!.stopVideoRecording().then((XFile file) {
      _logger.i('文件路径', file.path);
      toVideoPreview(path: file.path, isOriginVideo: false);
    });
  }

  toVideoPreview({required String path, required bool isOriginVideo}) {
    Get.toNamed(Routes.VIDEO_PREVIEW,
        arguments: VideoPreviewModel(
            previewType: VideoPreviewType.listAdd,
            localURL: path,
            text: selectedItemsToDisplay(),
            isOriginVideo: false));
  }

  albumClick() async {
    final assets = await pickVideos(context: Get.context!);
    if (assets != null && assets.isNotEmpty) {
      final calcelLoading = showLoading();
      final files = await Future.wait(assets.map((a) async {
        return await a.file;
      }));
      final pathes = files.map((f) => f!.path).toList();
      toVideoPreview(path: pathes.first, isOriginVideo: true);
      calcelLoading();
    }
  }

  switchClick() {
    if (isRecording.value) {
      HeySnackBar.showError("Camera is recording!");
    } else {
      if (isFrontCamera) {
        initBackCamera();
      } else {
        initFrontCamera();
      }
    }
  }

  initCamera(CameraLensDirection direction) async {
    var desArr = await availableCameras();
    CameraDescription? des;
    for (var d in desArr) {
      if (d.lensDirection == direction) {
        des = d;
        break;
      }
    }
    if (des == null) {
      HeySnackBar.showError('Camera is unavailable');
      return;
    }
    cameraVc = CameraController(des, ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.yuv420);
    await cameraVc!.initialize();
    await cameraVc!.prepareForVideoRecording();
    _logger.i(cameraVc!.value.aspectRatio);
    cameraInitialized.value = true;
    update();
  }

  initFrontCamera() async {
    disposeCamera();
    isFrontCamera = true;
    initCamera(CameraLensDirection.front);
  }

  initBackCamera() async {
    disposeCamera();
    isFrontCamera = false;
    initCamera(CameraLensDirection.back);
  }

  disposeCamera() {
    if (cameraVc != null) {
      cameraVc?.dispose();
      cameraVc = null;
    }
  }
}
