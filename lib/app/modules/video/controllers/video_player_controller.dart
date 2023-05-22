import 'dart:io';

import 'package:get/get.dart';
import 'package:heyya/app/core/utils/file_cache.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import 'package:heyya/app/data/model/media_entity.dart';
import 'package:heyya/app/flavors/build_config.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

class HeyVideoPlayerController extends GetxController {
  Logger _logger = BuildConfig.instance.config.logger;

  late VideoPlayerController videoPlayerController;
  Rx<bool> mediaInitialized = false.obs; //初始化成功
  Rx<bool> isPlaying = false.obs; //是否正在播放
  MediaEntity? video;

  @override
  void onInit() {
    super.onInit();
    video = Get.arguments;
  }

  @override
  void onReady() {
    super.onReady();
    initVideoPlayerController();
  }

  @override
  void onClose() {
    super.onClose();
    videoPlayerController.dispose();
  }

  void initVideoPlayerController() {
    if (video != null) {
      //缓存机制
      File? file = EMCache.shared.getFileSync(video!.url, EMFileType.video);
      if (file != null) {
        videoPlayerController = VideoPlayerController.file(file);
      } else {
        videoPlayerController = VideoPlayerController.network(video!.url);
      }
      videoPlayerController.setLooping(true);
      started();
    }
  }

  Future<void> started() async {
    var cancelLoading = showLoading();
    await videoPlayerController.initialize();
    mediaInitialized.value = true;
    playVideo();
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
}
