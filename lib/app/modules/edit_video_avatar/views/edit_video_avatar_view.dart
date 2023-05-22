// ignore_for_file: body_might_complete_normally_nullable
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/flutter_assets.dart';
import 'package:heyya/app/core/heyya_exports.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/widget/custom_scaffold.dart';
import '../controllers/edit_video_avatar_controller.dart';

class EditVideoAvatarView extends GetView<EditVideoAvatarController> {
  const EditVideoAvatarView({Key? key}) : super(key: key);

  Widget avatar() {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Container(
          width: Get.width - 40,
          child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ExtendedImage.network(
                    controller.avatarUrl ?? "",
                    fit: BoxFit.cover,
                    loadStateChanged: (state) {
                      if (state.extendedImageLoadState == LoadState.loading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return null;
                    },
                  ),
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                          onTap: () {
                            controller.takePhoto();
                          },
                          child: ExtendedImage.asset(Assets.iconChangeAvatar)))
                ],
              )),
        ));
  }

  Widget bottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Stack(
          children: [
            ExtendedImage.asset(Assets.buttonRetake),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  controller.later();
                },
                child: Container(
                  height: 44,
                  child: Center(
                    child: Text(
                      "Later",
                      style: textStyle(
                          fontSize: 16,
                          type: TextType.bold,
                          color: ThemeColors.c272b00),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              top: 30,
              left: 30,
              right: 29,
            )
          ],
        ),
        Stack(
          children: [
            ExtendedImage.asset(Assets.buttonEnjoyNow),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  controller.confirm();
                },
                child: Container(
                  height: 44,
                  child: Center(
                    child: Text(
                      "Confirm",
                      style: textStyle(
                          fontSize: 16,
                          type: TextType.bold,
                          color: ThemeColors.c272b00),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              top: 30,
              left: 30,
              right: 29,
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            GetBuilder<EditVideoAvatarController>(builder: (_) {
              return avatar();
            }),
            Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Do you want to set this picture as your main photo?",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                )),
            bottomRow()
          ],
        ),
      ),
    ));
  }
}
