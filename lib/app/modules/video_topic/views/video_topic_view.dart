// ignore_for_file: invalid_use_of_protected_member

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/heyya_exports.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/widget/custom_app_bar.dart';
import 'package:heyya/app/core/widget/custom_button.dart';
import 'package:heyya/app/core/widget/custom_scaffold.dart';

import '../controllers/video_topic_controller.dart';

class VideoTopicView extends GetView<VideoTopicController> {
  const VideoTopicView({Key? key}) : super(key: key);
  Widget bgView() => Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      top: 0,
      child: Image.asset(
        Assets.commonBg,
        fit: BoxFit.fill,
      ));

  Widget topicGridView() => Expanded(
          child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 140),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 14, crossAxisSpacing: 14),
        itemBuilder: (context, index) {
          VideoTopicItem item = controller.allItems[index];
          return CupertinoButton(
            padding: EdgeInsets.zero,
            pressedOpacity: 0.95,
            onPressed: () {
              item.isSelected = !item.isSelected;
              if (item.isSelected && controller.selectedItems.length == 3) {
                // 已选择三项，提示不能再选择
                item.isSelected = false;
                return;
              }
              int ret = controller.selectedItems.value
                  .indexWhere((element) => element == item);
              controller.selectedItems
                  .removeWhere((element) => element == item);
              if (ret == -1 && item.isSelected) {
                controller.selectedItems.value.add(item);
              }
              controller.update();
            },
            child: Container(
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: Image.asset(item.iconName).image),
                  borderRadius: BorderRadius.circular(16),
                  border: item.isSelected
                      ? Border.all(color: ThemeColors.cddef00, width: 2)
                      : Border.all(style: BorderStyle.none)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: Image.asset(Assets.topicMask).image,
                                fit: BoxFit.fitWidth)),
                        child: Text(
                          item.title,
                          style: textStyle(
                              type: TextType.regular,
                              fontSize: 12,
                              color: Colors.white),
                        ),
                      )),
                  if (item.isSelected)
                    Positioned(
                        top: 10,
                        right: 10,
                        child: Image.asset(Assets.photosChooseSelect))
                ],
              ),
            ),
          );
        },
        itemCount: controller.allItems.length,
      ));

  Widget mainView() => Padding(
        padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: MediaQueryData.fromWindow(window).padding.top +
                kBottomNavigationBarHeight +
                10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  controller.title,
                  style: textStyle(
                      type: TextType.bold, fontSize: 26, color: Colors.black),
                ),
                Expanded(child: Container()),
                Obx(() {
                  return Text(
                    '${controller.selectedItems.value.length}/3',
                    style: textStyle(
                        type: TextType.regular,
                        fontSize: 14,
                        color: Colors.black),
                  );
                })
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              controller.subTitle,
              style: textStyle(
                  type: TextType.regular, fontSize: 14, color: Colors.black),
            ),
            const SizedBox(
              height: 30,
            ),
            topicGridView()
          ],
        ),
      );

  Widget confirmWidget() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        child: CustomButton(
            state: CustomButtonState.selected,
            titleForNormal: "Next",
            onTap: () {
              controller.doneClick();
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: CustomAppBar(
          titleText: "",
          isBackButtonEnabled: true,
        ),
        body: GetBuilder<VideoTopicController>(
          builder: (controller) => Container(
            child: Stack(
              children: [bgView(), mainView(), confirmWidget()],
            ),
          ),
        ));
  }
}
