import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/flutter_assets.dart';
import 'package:heyya/app/core/utils/inset_tool.dart';
import 'package:heyya/app/core/values/app_fonts.dart';
import 'package:heyya/app/core/widget/custom_app_bar.dart';
import 'package:heyya/app/core/widget/custom_scaffold.dart';
import 'package:heyya/app/core/widget/heyya_container.dart';
import 'package:heyya/app/modules/video/models/video_preview_model.dart';
import 'package:video_player/video_player.dart';
import '../controllers/video_preview_controller.dart';

class VideoPreviewView extends GetView<VideoPreviewController> {
  const VideoPreviewView({Key? key}) : super(key: key);

  String confirmTitle() {
    return 'Confirm';
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: "",
        isBackButtonEnabled: true,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Image.asset(Assets.signCancelAll),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Container(
              width: Get.width,
              height: Get.height,
              child: Stack(fit: StackFit.loose, children: [
                Container(child: previewView()),
                Positioned(child: textfiledContainer(), bottom: 0),
                Positioned(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              button('Retake', Assets.buttonRetake, () {
                                controller.retake();
                              }),
                              button(confirmTitle(), Assets.buttonEnjoyNow, () {
                                controller.completed();
                              }),
                            ],
                          )
                        ],
                      ),
                    ),
                    bottom: 0)
              ])),
        ),
      ),
    );
  }

  Widget textfiledContainer() {
    return controller.videoPreviewModel?.previewType != VideoPreviewType.sign
        ? Container(
            alignment: Alignment.topCenter,
            width: Get.width,
            height: Get.height * 0.45,
            child: textfiledWidget(),
            decoration: BoxDecoration(
                // color: Colors.red,
                image: DecorationImage(
                    image: AssetImages.recordMask, fit: BoxFit.cover)))
        : Container();
  }

  Widget textfiledWidget() {
    final textColor = Colors.white.withAlpha(153);
    return Container(
        width: Get.width,
        height: 170,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 10, 10),
          child: TextField(
              controller: controller.textEditingController,
              onChanged: (value) {
                controller.content.value = value;
              },
              textInputAction: TextInputAction.done,
              style: textStyle(
                  type: TextType.regular, color: Colors.white, fontSize: 16),
              cursorColor: textColor,
              maxLength: 120,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  contentPadding:
                      Insets.insetsWith(type: InsetsType.all, margin: 0),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintStyle:
                      textStyle(type: TextType.regular, color: textColor),
                  hintText: "Click here to describe yourself",
                  counterStyle: textStyle(
                      type: TextType.regular, color: textColor, fontSize: 12),
                  counterText: "")),
        ));
  }

  Widget button(String text, String img, VoidCallback callback) {
    double w = (Get.width) * 0.5;
    double h = (Get.width - 20) * 0.5 / 178 * 137;
    return GestureDetector(
      onTap: () => callback(),
      child: HeyContainer(
        // bgColor: ThemeColors.randomSparkTitleColor(),
        padding: EdgeInsets.only(bottom: h * 0.24),
        width: w,
        height: h,
        child: Center(child: Text(text)),
        bgImgPath: img,
      ),
    );
  }

  Container previewView() {
    return Container(
      width: Get.width,
      height: Get.height,
      child: GestureDetector(
        onTap: () {
          controller.playVideo();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Obx(() => controller.playerInitialized.value
                  ? AspectRatio(
                      aspectRatio:
                          controller.videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(controller.videoPlayerController),
                    )
                  : Center(child: Text('Loading'))),
            ),
            Positioned.fill(
              child: Obx(() => controller.isPlaying.value
                  ? Container()
                  : Center(child: Image.asset(Assets.sparkPause))),
            )
          ],
        ),
      ),
    );
  }
}
