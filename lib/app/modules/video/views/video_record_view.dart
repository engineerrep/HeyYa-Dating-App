import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/modules/video/controllers/video_record_controller.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import '../../../core/values/app_fonts.dart';
import '../../../core/widget/heyya_container.dart';
import '../component/video_tip_view.dart';

class VideoRecordView extends GetView<VideoRecordController> {
  const VideoRecordView({Key? key}) : super(key: key);

  Widget camera() {
    return Container(
      child: Obx(() => (controller.cameraInitialized.value
          ? ClipRect(
              child: OverflowBox(
              alignment: Alignment.topCenter,
              child: FittedBox(
                  child: Container(
                      width: Get.width,
                      height: Get.height,
                      child: AspectRatio(
                        aspectRatio: controller.cameraVc!.value.aspectRatio,
                        child: CameraPreview(controller.cameraVc!),
                      ))),
            ))
          : Container(color: Colors.black))),
    );
  }

  Widget recordButton() {
    return Obx(() {
      if (controller.isRecording.value) {
        return Center(
            child: GestureDetector(
          child: Stack(
            children: [
              CircularPercentIndicator(
                radius: 32.0,
                lineWidth: 5.0,
                animation: true,
                animationDuration: controller.maxTime * 1000,
                percent: 1,
                center: Image.asset(Assets.recordStart),
                progressColor: Colors.white,
                backgroundColor: Colors.white.withOpacity(0.2),
              )
            ],
          ),
          onTap: () {
            controller.stopRecordVideo();
          },
        ));
      } else {
        return GestureDetector(
          child: Image.asset(Assets.recordPause),
          onTap: () {
            controller.isRecording.value = true;
            controller.startRecordVideo();
          },
        );
      }
    });
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
        title: Obx(() => HeyContainer(
            alignment: Alignment.center,
            width: 76,
            height: 30,
            radius: 4,
            bgColor: Colors.black.withOpacity(0.2),
            child: Text(
                '00:' +
                    controller.duration.value.toString().padLeft(2, '0') +
                    's',
                style: textStyle(
                    fontSize: 16, color: Colors.white, type: TextType.bold)))),
        centerTitle: true,
      ),
      body: Container(
        child: SafeArea(
          top: false,
          child: Stack(
            children: [
              Positioned.fill(child: camera()),
              Obx(() => controller.shouldShowShortTip.value
                  ? Positioned(
                      top: 7,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                          child: Center(
                              child: Text(
                        'The video must be 5 seconds or more.',
                        style:
                            textStyle(fontSize: 14, color: Color(0xffFF4B5F)),
                      ))))
                  : Container()),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 130,
                  child: Center(child: VideoTipView(isGuiding: false))),
              Positioned(
                  bottom: 44,
                  child: Container(
                    height: 74,
                    width: Get.width,
                    child: recordButton(),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
