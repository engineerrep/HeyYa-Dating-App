import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/heyya_exports.dart';
import 'package:heyya/app/core/widget/custom_app_bar.dart';
import 'package:heyya/app/core/widget/custom_button.dart';
import 'package:heyya/app/core/widget/custom_scaffold.dart';
import 'package:heyya/app/modules/video_list/views/video_list_view.dart';

import '../controllers/contact_info_controller.dart';

class ContactInfoView extends GetView<ContactInfoController> {
  const ContactInfoView({Key? key}) : super(key: key);

  Widget infoItemWidget(String title, String hint,
      {TextEditingController? textEditingController}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textStyle(fontSize: 16, type: TextType.bold),
          ),
          const SizedBox(
            height: 12,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: 20),
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: hint,
                  hintStyle: textStyle(fontSize: 14, color: Color(0xffBFC4C3))),
            ),
          )
        ],
      ),
    );
  }

  Widget confirmWidget() {
    final state = (controller.canSave())
        ? CustomButtonState.selected
        : CustomButtonState.disable;
    final button = CustomButton(
        state: state,
        titleForNormal: "Save",
        onTap: () => controller.saveAction());
    return button;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWithBackground(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Image.asset(Assets.cancelAll),
            onPressed: () => Get.back()),
        title: Text(
          'Social Account',
          style:
              textStyle(type: TextType.bold, fontSize: 20, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              infoItemWidget('Phone Number', 'Ask Me',
                  textEditingController: controller.phoneEditingController),
              infoItemWidget('Email', 'Ask Me',
                  textEditingController: controller.emailEditingController),
              infoItemWidget('Instagram', 'Ask Me',
                  textEditingController: controller.instagramEditingController),
              infoItemWidget('Snapchat', 'Ask Me',
                  textEditingController: controller.snapchatEditingController),
              infoItemWidget('Tiktok', 'Ask Me',
                  textEditingController: controller.tiktokEditingController),
              GetBuilder<ContactInfoController>(
                builder: (controller) => confirmWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
