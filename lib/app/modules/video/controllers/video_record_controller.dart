import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/flavors/build_config.dart';
import 'package:heyya/app/modules/video/controllers/video_preview_controller.dart';
import 'package:heyya/app/modules/video/models/video_preview_model.dart';
import 'package:logger/logger.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import '../../../core/utils/hey_snack_bar.dart';
import '../../../routes/app_pages.dart';

class VideoRecordController extends GetxController {
  CameraController? cameraVc;
  Rx<bool> cameraInitialized = false.obs;
  Rx<bool> isRecording = false.obs;
  Rx<int> duration = 0.obs;
  Logger _logger = BuildConfig.instance.config.logger;
  Rx<bool> shouldShowShortTip = false.obs;
  final maxTime = 20;
  Timer? timer;

  VideoPreviewModel? videoPreviewModel;

  @override
  void onInit() {
    super.onInit();
    videoPreviewModel = Get.arguments as VideoPreviewModel?;
    initCamera();
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
      toVideoPreview(file.path);
    });
  }

  toVideoPreview(String path) {
    final previewType = videoPreviewModel?.previewType;
    if (videoPreviewModel != null && previewType != null) {
      switch (previewType) {
        case VideoPreviewType.sign:
          Get.toNamed(Routes.VIDEO_PREVIEW,
              arguments: VideoPreviewModel(
                  previewType: VideoPreviewType.sign, localURL: path));
          break;
        case VideoPreviewType.add:
        case VideoPreviewType.listAdd:
          Get.toNamed(Routes.VIDEO_PREVIEW,
              arguments: VideoPreviewModel(
                  previewType: previewType,
                  localURL: path,
                  video: videoPreviewModel?.video));
          break;
        case VideoPreviewType.edit: //返回到预览
          final previewController = Get.find<VideoPreviewController>();
          previewController.newVideoPreviewModel = VideoPreviewModel(
              previewType: VideoPreviewType.edit,
              localURL: path,
              video: videoPreviewModel?.video);
          previewController.addNewVideoModel();
          Get.until((route) => Get.currentRoute == Routes.VIDEO_PREVIEW);
          break;
      }
    }
  }

  initCamera() async {
    var desArr = await availableCameras();
    CameraDescription? des;
    for (var d in desArr) {
      if (d.lensDirection == CameraLensDirection.front) {
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
    cameraInitialized.value = true;
    _logger.i(cameraVc!.value.aspectRatio);
  }
}
