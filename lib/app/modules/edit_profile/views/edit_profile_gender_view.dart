import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets_images.dart';
import 'package:heyya/app/core/enum/gender_type.dart';
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
import 'package:heyya/app/modules/spark/controllers/spark_controller.dart';

class EditProfileGenderView extends GetView<EditProfileController> {
  EditProfileGenderView({Key? key}) : super(key: key);

  Widget femaleColumn() {
    return Column(
      children: [
        Obx(() => femaleWidget()),
        Insets.top(margin: 12),
        Text(genderForDisplay(GenderType.female),
            style: textStyle(
                fontSize: 18,
                color: ThemeColors.c1f2320,
                type: TextType.regular)),
      ],
    );
  }

  Widget maleColumn() {
    return Column(
      children: [
        Obx(() => maleWidget()),
        Insets.top(margin: 12),
        Text(genderForDisplay(GenderType.male),
            style: textStyle(
                fontSize: 18,
                color: ThemeColors.c1f2320,
                type: TextType.regular)),
      ],
    );
  }

  Widget femaleWidget() {
    if (controller.sex.value == genderValue(GenderType.female)) {
      return ExtendedImage(image: AssetImages.iconFemaleSel);
    }
    return GestureDetector(
      child: ExtendedImage(image: AssetImages.iconFemaleDef),
      onTap: () {
        controller.sex.value = genderValue(GenderType.female);
      },
    );
  }

  Widget maleWidget() {
    if (controller.sex.value == genderValue(GenderType.male)) {
      return ExtendedImage(image: AssetImages.iconMaleSel);
    }
    return GestureDetector(
      child: ExtendedImage(image: AssetImages.iconMaleDef),
      onTap: () {
        controller.sex.value = genderValue(GenderType.male);
      },
    );
  }

  Widget editProfileButton() {
    final state = controller.sex.value.length > 0
        ? CustomButtonState.selected
        : CustomButtonState.disable;
    return CustomButton.editProfileButton(state: state, onTap: confirmClick);
  }

  void confirmClick() async {
    final cancelLoading = showLoading();
    final success = await controller.editGender();
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
        width: Get.width,
        height: Get.height,
        color: ThemeColors.cddef00,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Insets.top(margin: topOffSet),
            Text("I am a",
                style: textStyle(
                    fontSize: 30,
                    color: ThemeColors.c1f2320,
                    type: TextType.bold)),
            Insets.top(margin: Get.height * 0.075),
            Column(
              children: [
                femaleColumn(),
                Insets.top(margin: 36),
                maleColumn(),
              ],
            ),
            Expanded(child: Container()),
            Obx(() => editProfileButton()),
          ],
        ),
      ),

      // )
    );
  }
}
