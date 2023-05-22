import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/utils/inset_tool.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/values/app_fonts.dart';
import 'package:heyya/app/core/widget/custom_app_bar.dart';
import 'package:heyya/app/core/widget/custom_button.dart';
import 'package:heyya/app/core/widget/custom_scaffold.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/modules/edit_profile/controllers/edit_profile_controller.dart';

class EditProfileAboutmeView extends GetView<EditProfileController> {
  EditProfileAboutmeView({Key? key}) : super(key: key);

  Widget textfiledWidget() {
    return Container(
        height: 170,
        color: Colors.white,
        margin: Insets.insetsWith(type: InsetsType.leftRight),
        padding: EdgeInsets.fromLTRB(20, 20, 10, 10),
        child: TextField(
            onChanged: (value) {
              print(value);
              controller.aboutMe.value = value;
            },
            textInputAction: TextInputAction.done,
            style: textStyle(
                type: TextType.regular,
                color: ThemeColors.c1f2320,
                fontSize: 16),
            cursorColor: ThemeColors.c1f2320,
            maxLength: 300,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              contentPadding:
                  Insets.insetsWith(type: InsetsType.all, margin: 0),
              border: OutlineInputBorder(borderSide: BorderSide.none),
              hintStyle:
                  textStyle(type: TextType.regular, color: ThemeColors.c7f8a87),
              hintText: "Introduce yourself...",
              counterStyle: textStyle(
                  type: TextType.regular,
                  color: ThemeColors.c7f8a87,
                  fontSize: 12),
            )));
  }

  Widget editProfileButton() {
    final state = controller.aboutMe.value.length > 0
        ? CustomButtonState.selected
        : CustomButtonState.disable;
    return CustomButton.editProfileButton(state: state, onTap: confirmClick);
  }

  void confirmClick() async {
    final cancelLoading = showLoading();
    final success = await controller.editAboutMe();
    cancelLoading();
    if (success) {
      HeySnackBar.showSuccess("Success");
      UserProfile.editProfileComplete();
    }
  }

  Widget _child() {
    if (Get.height == 667) {
      return SingleChildScrollView(
        child: aboutMeContainer(),
      );
    } else {
      return aboutMeContainer();
    }
  }

  Widget aboutMeContainer() {
    final topOffSet = Get.height < 700 ? Get.height * 0.12 : Get.height * 0.17;
    return Container(
      width: Get.width,
      height: Get.height,
      color: ThemeColors.cddef00,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Insets.top(margin: topOffSet),
          Text("About me",
              style: textStyle(
                  fontSize: 30,
                  color: ThemeColors.c1f2320,
                  type: TextType.bold)),
          Insets.top(margin: 31),
          textfiledWidget(),
          Expanded(child: Container()),
          Obx(() => editProfileButton()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          titleText: "",
          isBackButtonEnabled: true,
        ),
        body: GestureDetector(
            child: _child(),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            }));
  }
}
