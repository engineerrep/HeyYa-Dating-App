import 'dart:io';

import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/return_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/enum/media_type.dart';
import 'package:heyya/app/core/extensions/UserEntity+Ext.dart';
import 'package:heyya/app/core/utils/app_manager.dart';
import 'package:heyya/app/core/utils/file_cache.dart';
import 'package:heyya/app/core/utils/get_route_helper.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import 'package:heyya/app/data/repository/media_repository.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/modules/edit_profile/controllers/edit_profile_controller.dart';
import 'package:heyya/app/modules/profile/controllers/profile_controller.dart';
import 'package:heyya/app/modules/verified_videos/controllers/verified_videos_controller.dart';
import 'package:heyya/app/modules/verified_videos/views/verified_videos_view.dart';
import 'package:heyya/app/modules/video/models/video_preview_model.dart';
import 'package:heyya/app/network/exceptions/base_exception.dart';
import 'package:heyya/app/routes/app_pages.dart';
import 'package:logger/logger.dart';
import 'package:tim_ui_kit/business_logic/model/profile_model.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/utils/video_thumbnail_wrapper.dart';
import '../../../data/model/media_entity.dart';
import '../../../flavors/build_config.dart';

class VideoPreviewController extends GetxController {
  MediaRepository repository = MediaRepository();

  Logger _logger = BuildConfig.instance.config.logger;

  late VideoPlayerController videoPlayerController;
  Rx<bool> playerInitialized = false.obs; //初始化成功
  Rx<bool> isPlaying = false.obs; //是否正在播放

  TextEditingController textEditingController = TextEditingController();
  var content = "".obs;

  VideoPreviewModel? videoPreviewModel;
  VideoPreviewModel? newVideoPreviewModel; //local

  @override
  void onInit() {
    super.onInit();
    videoPreviewModel = Get.arguments as VideoPreviewModel?;
    initText();
  }

  void initText() {
    if (videoPreviewModel?.previewType != VideoPreviewType.sign) {
      textEditingController.text = videoPreviewModel?.video?.content ?? "";
    }
    final text = videoPreviewModel?.text;
    if (text != null && text.isNotEmpty) {
      content.value = text;
      textEditingController.text = text;
    }
  }

  retake() {
    _pause();
    final previewType = videoPreviewModel?.previewType;
    if (previewType != null) {
      switch (previewType) {
        case VideoPreviewType.edit:
          Get.toNamed(Routes.VIDEO_GUIDING, arguments: videoPreviewModel);
          break;
        case VideoPreviewType.listAdd:
          Get.back();
          break;
        case VideoPreviewType.add:
          Get.until((route) => Get.currentRoute == Routes.VIDEO_GUIDING);
          break;
        case VideoPreviewType.sign:
          Get.until((route) => Get.currentRoute == Routes.VIDEO_GUIDING);
          //Get.back();
          break;
      }
    }
  }

  Future<String?> uploadPhoto({required String localURL}) async {
    try {
      final urls =
          await repository.uploadMedias([XFile(localURL)], MediaType.PICTURE);
      return urls.first;
    } on BaseException catch (e) {
      HeySnackBar.showError(e.message);
      return null;
    }
  }

  //上传视频
  Future<String?> uploadVideo(
      {required String localURL, required bool removeOriginFile}) async {
    try {
      //压缩视频后上传
      Directory dir = await getApplicationDocumentsDirectory();
      String videoPath =
          dir.path + EMCache.shared.getDirectoryPath(EMFileType.video);
      videoPath += '/temp.mp4';

      File tempFile = File(videoPath);
      if (tempFile.existsSync()) {
        tempFile.deleteSync();
      }

      var originFile = File(localURL);
      int originFileLength = originFile.lengthSync();

      print('Origial video file size: $originFileLength');

      String crf = '28';
      if (Platform.isAndroid) crf = '35';

      String cmd =
          '-i ${originFile.path} -c:v libx264 -crf $crf -c:a copy $videoPath';
      if (originFileLength < 1024 * 1024 * 10) {
        cmd =
            '-i ${originFile.path} -c:v libx264 -b:v 1200k -c:a copy $videoPath';
      }

      FFmpegSession ffmpegSession = await FFmpegKit.execute(cmd);
      final returnCode = await ffmpegSession.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        // SUCCESS
        // 删除源文件
        if (removeOriginFile) {
          await originFile.delete();
        }
        originFile = tempFile;
        print('Compressed video file size:${originFile.lengthSync()}');
      } else if (ReturnCode.isCancel(returnCode)) {
        // CANCEL
        HeySnackBar.showError("Post video failed");
        return null;
      } else {
        // ERROR
        HeySnackBar.showError("Post video failed");
        return null;
      }

      final urls = await repository
          .uploadMedias([XFile(originFile.path)], MediaType.VIDEO);
      return urls.first;
    } on BaseException catch (e) {
      HeySnackBar.showError(e.message);
      return null;
    }
  }

  completed() async {
    _pause();
    final remoteURL = videoPreviewModel?.video?.url ?? "";
    var previewType = videoPreviewModel?.previewType;
    final isOriginVideo = videoPreviewModel?.isOriginVideo ?? false;
    var cancelLoading = showLoading();
    final user = Session.getUser()!;
    String? mp4;
    String? cover;
    bool success = true;

    if (newVideoPreviewModel != null) {
      final localURL = newVideoPreviewModel?.localURL ?? "";
      try {
        VideoThumbnailData? data =
            await VideoThumbnailWrapper.getVideoThumbnailFile(localURL,
                maxWidth: Get.width.toInt(), maxHeight: Get.height.toInt());
        if (data != null) {
          cover = await uploadPhoto(localURL: data.thumbnail.path);
        }
      } catch (_) {}
      mp4 = await uploadVideo(localURL: localURL, removeOriginFile: true);
    } else if (previewType == VideoPreviewType.edit) {
      mp4 = remoteURL;
    } else if (previewType == VideoPreviewType.sign ||
        previewType == VideoPreviewType.add ||
        previewType == VideoPreviewType.listAdd) {
      final localURL = videoPreviewModel?.localURL ?? "";
      try {
        VideoThumbnailData? data =
            await VideoThumbnailWrapper.getVideoThumbnailFile(localURL,
                maxWidth: Get.width.toInt(), maxHeight: Get.height.toInt());
        if (data != null) {
          cover = await uploadPhoto(localURL: data.thumbnail.path);
        }
      } catch (_) {}
      mp4 = await uploadVideo(
          localURL: localURL, removeOriginFile: isOriginVideo);
    }
    if (mp4 == null) {
      cancelLoading();
      return;
    }

    MediaEntity? media;
    try {
      var text = textEditingController.text;
      final mediaId = videoPreviewModel?.video?.id;
      if (previewType != null) {
        switch (previewType) {
          case VideoPreviewType.edit:
            media = await repository.saveMedia(
                mp4, videoPreviewModel?.video?.type ?? MediaType.VERIFY_VIDEO,
                content: text, mediaId: mediaId, cover: cover);
            break;
          case VideoPreviewType.add:
            var videoType = MediaType.VERIFY_VIDEO;
            if (!user.hasMainVideo()) {
              videoType = MediaType.MAIN_VIDEO;
            }
            media = await repository.saveMedia(mp4, videoType,
                content: text, mediaId: mediaId, cover: cover);
            break;
          case VideoPreviewType.listAdd:
            media = await repository.saveMedia(mp4, MediaType.VIDEO,
                content: text, mediaId: mediaId, cover: cover);
            break;
          case VideoPreviewType.sign:
            media = await repository.saveMedia(mp4, MediaType.MAIN_VIDEO,
                content: text, mediaId: mediaId, cover: cover);
            break;
        }
      }
    } on BaseException catch (e) {
      HeySnackBar.showError(e.message);
      success = false;
    }
    cancelLoading();
    if (success && previewType != null) {
      switch (previewType) {
        case VideoPreviewType.listAdd:
          UserManager.updateUserProfile();
          GetRouteHelper.backToSpark();
          break;
        case VideoPreviewType.sign:
          UserManager.updateUserProfile();
          GetRouteHelper.backToTabbar();
          break;
        case VideoPreviewType.add:
        case VideoPreviewType.edit:
          Get.find<VerifiedVideosController>().updateProfile();
          try {
            final _ = Get.find<EditProfileController>();
            Get.until((route) => Get.currentRoute == Routes.EDIT_PROFILE);
          } catch (_) {
            Get.until((route) => Get.currentRoute == Routes.VERIFIED_VIDEOS);
          }
          break;
      }
    }
  }

  Future<void> started() async {
    var cancelLoading = showLoading();
    await videoPlayerController.initialize();

    playerInitialized.value = true;
    cancelLoading();
  }

  playVideo() {
    if (isPlaying.value) {
      _pause();
    } else {
      _play();
    }
  }

  _play() {
    videoPlayerController.play();
    isPlaying.value = true;
  }

  _pause() {
    videoPlayerController.pause();
    isPlaying.value = false;
  }

  @override
  void onReady() {
    super.onReady();
    initVideoPlayerController();
  }

  void initVideoPlayerController() {
    final localURL = videoPreviewModel?.localURL ?? "";
    final remoteURL = videoPreviewModel?.video?.url ?? "";
    final previewType = videoPreviewModel?.previewType;
    if (newVideoPreviewModel != null) {
      //已编辑：编辑后生成newVideoPreviewModel
      videoPlayerController = VideoPlayerController.file(
          File(newVideoPreviewModel?.localURL ?? ""));
    } else if (previewType == VideoPreviewType.edit) {
      //缓存机制
      File? file = EMCache.shared.getFileSync(remoteURL, EMFileType.video);
      if (file != null) {
        videoPlayerController = VideoPlayerController.file(file);
      } else {
        videoPlayerController = VideoPlayerController.network(remoteURL);
      }
    } else {
      videoPlayerController = VideoPlayerController.file(File(localURL));
    }
    videoPlayerController.setLooping(true);
    started();
  }

  void addNewVideoModel() {
    videoPlayerController.dispose();
    initVideoPlayerController();
    playerInitialized.value = false;
  }

  @override
  void onClose() {
    super.onClose();
    _pause();
    videoPlayerController.dispose();
    textEditingController.dispose();
  }
}
