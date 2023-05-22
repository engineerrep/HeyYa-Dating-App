import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/values/app_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../controllers/video_player_controller.dart';

class HeyVideoPlayerView extends GetView<HeyVideoPlayerController> {
  const HeyVideoPlayerView({Key? key}) : super(key: key);

  Container previewView() {
    return Container(
      width: Get.width,
      height: Get.height,
      child: GestureDetector(
        onTap: () {
          if (controller.mediaInitialized.value) {
            controller.playVideo();
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: camera(),
            ),
            Positioned.fill(
              child: Obx(() => controller.isPlaying.value
                  ? Container()
                  : Center(child: Image.asset(Assets.sparkPause))),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: textfiledWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget camera() {
    return Container(
      child: Obx(() => (controller.mediaInitialized.value
          ? ClipRect(
              child: OverflowBox(
              alignment: Alignment.center,
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Container(
                      width: Get.width,
                      height: Get.width /
                          controller.videoPlayerController.value.aspectRatio,
                      child: AspectRatio(
                        aspectRatio:
                            controller.videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(controller.videoPlayerController),
                      ))),
            ))
          : Center(child: Text('Loading')))),
    );
  }

  Widget textfiledWidget() {
    return Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(20),
        width: Get.width,
        height: 150,
        child: GetBuilder<HeyVideoPlayerController>(builder: (controller) {
          return Text(controller.video?.content ?? "",
              style: textStyle(
                  type: TextType.regular, color: Colors.white, fontSize: 16));
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Image.asset(Assets.signCancelAll),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: previewView());
  }
}
