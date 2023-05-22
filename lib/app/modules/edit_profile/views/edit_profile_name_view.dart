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

import '../controllers/edit_profile_controller.dart';

class EditProfileNameView extends GetView<EditProfileController> {
  const EditProfileNameView({Key? key}) : super(key: key);

  Widget textfiledWidget() {
    return SizedBox(
        width: 240,
        height: 56,
        child: Container(
          color: Colors.white,
          padding: Insets.insetsWith(type: InsetsType.all, margin: 16),
          child: TextField(
              onChanged: (value) {
                controller.userName.value = value;
              },
              style: textStyle(
                  type: TextType.regular,
                  color: ThemeColors.c1f2320,
                  fontSize: 16),
              cursorColor: ThemeColors.c1f2320,
              maxLength: 16,
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.left,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                contentPadding:
                    Insets.insetsWith(type: InsetsType.all, margin: 0),
                border: OutlineInputBorder(borderSide: BorderSide.none),
                hintText: "Your name...",
                counterText: "",
              )),
        ));
  }

  Widget editProfileButton() {
    final state = controller.userName.value.length > 0
        ? CustomButtonState.selected
        : CustomButtonState.disable;
    return CustomButton.editProfileButton(state: state, onTap: confirmClick);
  }

  void confirmClick() async {
    final context = Get.context;
    if (context != null) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    final cancelLoading = showLoading();
    final success = await controller.editName();
    cancelLoading();
    if (success) {
      HeySnackBar.showSuccess("Success");
      UserProfile.editProfileComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final topOffSet = Get.height < 700 ? Get.height * 0.12 : Get.height * 0.17;
    return CustomScaffold(
      appBar: CustomAppBar(
        titleText: "",
        isBackButtonEnabled: true,
      ),
      body: Container(
        color: ThemeColors.cddef00,
        width: Get.width,
        height: Get.height,
        child:
            // SingleChildScrollView(
            //   physics: BouncingScrollPhysics(),
            // child:
            Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Insets.top(margin: topOffSet),
            Text("What’s your name?",
                style: textStyle(
                    fontSize: 30,
                    color: ThemeColors.c1f2320,
                    type: TextType.bold)),
            Insets.top(margin: 24),
            textfiledWidget(),
            Expanded(child: Container()),
            Obx(() => editProfileButton()),
          ],
        ),
      ),
      // )
    );
  }
}
