import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyya/app/core/assets/flutter_assets.dart';
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

class EditProfileAvatarView extends GetView<EditProfileController> {
  EditProfileAvatarView({Key? key}) : super(key: key);

  //final userController = Get.find<EditProfileController>();

  Widget editProfileButton() {
    final state = controller.avatar.value.length > 0
        ? CustomButtonState.selected
        : CustomButtonState.disable;
    return CustomButton.editProfileButton(state: state, onTap: confirmClick);
  }

  void confirmClick() async {
    final cancelLoading = showLoading();
    final avatar = controller.avatar.value;
    final success = await controller.editAvatar(avatar: avatar);
    cancelLoading();
    if (success) {
      HeySnackBar.showSuccess("Success");
      UserProfile.editProfileComplete();
    }
  }

  Widget avatarWidget() {
    final avatar = controller.avatar.value;
    if (avatar.length > 0) {
      return ExtendedImage.network(
        avatar,
        fit: BoxFit.cover,
      );
    } else {
      return ExtendedImage(image: AssetImages.btnUploadAvatar);
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
        child:
            //  SingleChildScrollView(
            //   physics: BouncingScrollPhysics(),
            //   child:
            Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Insets.top(margin: topOffSet),
            Text("Upload Avatar",
                style: textStyle(
                    fontSize: 30,
                    color: ThemeColors.c1f2320,
                    type: TextType.bold)),
            Insets.top(margin: 24),
            Obx(() => GestureDetector(
                  child: Container(
                    child: avatarWidget(),
                    width: 160,
                    height: 160,
                  ),
                  onTap: () {
                    //controller.takePhoto();
                    controller.choosePhoto();
                  },
                )),
            Insets.top(margin: 30),
            Container(
              width: 295,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                      width: 196,
                      height: 110,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ExtendedImage(
                                  image: AssetImages.imageFauseAvatar),
                              Container(
                                alignment: Alignment.bottomCenter,
                                child: ExtendedImage(
                                    image: AssetImages.iconFauseAvatar),
                              ),
                            ],
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ExtendedImage(
                                  image: AssetImages.imageRightAvatar),
                              Container(
                                alignment: Alignment.bottomCenter,
                                child: ExtendedImage(
                                    image: AssetImages.iconRightAvatar),
                              ),
                            ],
                          )
                        ],
                      )),
                  Insets.top(margin: 12),
                  Text(
                    "Take a profile photo clearly showing your face.",
                    textAlign: TextAlign.center,
                    style: textStyle(fontSize: 14, color: ThemeColors.c7f8a87),
                  ),
                  Insets.top(margin: 30),
                ],
              ),
            ),
            Insets.top(margin: 0),
            Expanded(child: Container()),
            Obx(() => editProfileButton()),
          ],
        ),
      ),
      // )
    );
  }
}
