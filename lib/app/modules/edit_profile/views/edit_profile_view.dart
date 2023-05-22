import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/assets/assets_images.dart';
import 'package:heyya/app/core/enum/gender_type.dart';
import 'package:heyya/app/core/utils/get_route_helper.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/utils/inset_tool.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/values/app_fonts.dart';
import 'package:heyya/app/core/widget/custom_app_bar.dart';
import 'package:heyya/app/core/widget/custom_scaffold.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/modules/edit_profile/controllers/edit_profile_controller.dart';
import 'package:heyya/app/modules/spark/controllers/spark_controller.dart';
import 'package:heyya/app/modules/verified_videos/controllers/verified_videos_controller.dart';
import 'package:heyya/app/modules/verified_videos/views/verified_videos_view.dart';

class EditProfileView extends GetView<EditProfileController> {
  EditProfileView({Key? key}) : super(key: key);

  Widget avatarWidget(BuildContext context) {
    final double avatarWH = 160;
    return Container(
      width: Get.width,
      height: avatarWH,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                width: Get.width,
                height: avatarWH * 0.5,
                color: ThemeColors.cddef00,
              ),
              Container(
                width: Get.width,
                height: avatarWH * 0.5,
                color: ThemeColors.cf6f6f6,
              )
            ],
          ),
          Container(
            alignment: Alignment.center,
            width: avatarWH,
            height: avatarWH,
            child: GestureDetector(
                child: avatarContainer(),
                onTap: () {
                  controller.takePhoto();
                }),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
          ),
          Positioned(
            child: GestureDetector(
                child: ExtendedImage(image: AssetImages.iconChangeAvatar),
                onTap: () {
                  controller.takePhoto();
                }),
            left: (Get.width / 2 + 80 - 42),
            bottom: -10,
          ),
        ],
      ),
    );
  }

  Widget avatarContainer() {
    final double containerWH = 118;
    final avatar = Session.shard().user?.value.avatar;
    if (controller.avatar.value.length > 0) {
      final avatar = controller.avatar.value;
      return ClipOval(
        clipBehavior: Clip.antiAlias,
        child: ExtendedImage.network(
          avatar,
          width: containerWH,
          height: containerWH,
          fit: BoxFit.cover,
        ),
      );
    } else if (avatar != null && avatar.isNotEmpty) {
      return Container(
        width: containerWH,
        height: containerWH,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(59),
            image: DecorationImage(
              image: ExtendedImage.network(
                avatar,
              ).image,
              fit: BoxFit.cover,
            )),
      );
    } else {
      return Container(
        width: containerWH,
        height: containerWH,
        decoration: BoxDecoration(
            color: ThemeColors.cddef00,
            borderRadius: BorderRadius.circular(59),
            image: DecorationImage(
                image: ExtendedImage.asset(
              Assets.imageBgAvatar,
              fit: BoxFit.cover,
            ).image)),
      );
    }
  }

  Widget genderWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      genderButton(type: GenderType.female),
      SizedBox(width: 13),
      genderButton(type: GenderType.male),
    ]);
  }

  Widget genderButton({required GenderType type}) {
    var color = Colors.white;
    if (type == GenderType.female) {
      color = controller.sex.value == genderValue(GenderType.female)
          ? ThemeColors.cddef00
          : Colors.white;
    } else {
      color = controller.sex.value == genderValue(GenderType.male)
          ? ThemeColors.cddef00
          : Colors.white;
    }

    final provider = (type == GenderType.female)
        ? AssetImages.iconFemaleProfile
        : AssetImages.iconMaleProfile;

    final text = (type == GenderType.female)
        ? genderForDisplay(GenderType.female)
        : genderForDisplay(GenderType.male);

    return Expanded(
      child: GestureDetector(
        child: Container(
          alignment: Alignment.centerLeft,
          height: 60,
          child: Row(
            children: [
              SizedBox(width: 5),
              ExtendedImage(image: provider),
              Text(text),
            ],
          ),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(8)),
        ),
        onTap: () {
          controller.sex.value = genderValue(type);
        },
      ),
    );
  }

  Widget aboutmeWidget() {
    return Container(
        height: 170,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        // margin: Insets.insetsWith(type: InsetsType.leftRight),
        padding: EdgeInsets.all(10),
        child: TextField(
            controller: controller.aboutController,
            onChanged: (value) {
              print(value);
              controller.aboutMe.value = value;
            },
            style: textStyle(
                type: TextType.regular,
                color: ThemeColors.c1f2320,
                fontSize: 16),
            cursorColor: ThemeColors.c1f2320,
            maxLength: 300,
            maxLines: null,
            expands: true,
            textInputAction: TextInputAction.done,
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

  Widget nameWidget() {
    return SizedBox(
        height: 60,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          padding: Insets.insetsWith(type: InsetsType.all, margin: 16),
          child: TextField(
              controller: controller.nameController,
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
                hintText: "Your name",
                counterText: "",
              )),
        ));
  }

  void confirmClick() async {
    final cancelLoading = showLoading();
    if (controller.avatar.value.length > 0) {
      final avatar = controller.avatar.value;
      controller.avatar.value = avatar;
    }
    final success = await controller.editProfile();
    //刷新Spark
    Get.find<SparkController>().loadNext(true);
    cancelLoading();
    if (success) {
      HeySnackBar.showSuccess("Success");
      GetRouteHelper.backToRoot();
    }
  }

  Widget titleText(String title) {
    return Text(title,
        textAlign: TextAlign.left,
        style: textStyle(
            fontSize: 16, color: ThemeColors.c1f2320, type: TextType.bold));
  }

  Widget optionalText(String title) {
    return Text(title,
        textAlign: TextAlign.left,
        style: textStyle(
            fontSize: 14, color: Colors.grey, type: TextType.regular));
  }

  double verifiedVideosViewHeight() {
    final videosLength = Get.find<VerifiedVideosController>().videos.length;
    if (videosLength == 0) {
      return 100;
    } else {
      final moreLine = videosLength % 3 > 0 ? 1 : 0;
      final width = (Get.width - 34) / 3;
      final height = width / (114 / 152);
      final totalHeight = (moreLine + videosLength ~/ 3) * height + 150;
      return totalHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double containerTopInset = Get.height * 0.1955;
    return CustomScaffold(
        appBar: CustomAppBar(
          titleText: "Profile",
          actions: [
            TextButton(
                onPressed: confirmClick,
                child: Text("Done",
                    style: textStyle(
                        fontSize: 16,
                        color: ThemeColors.c1f2320,
                        type: TextType.regular))),
          ],
        ),
        body: Container(
          width: Get.width,
          height: Get.height,
          child: Container(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: containerTopInset),
              physics: ClampingScrollPhysics(),
              child: Container(
                  child: Column(
                children: [
                  Obx(() {
                    return avatarWidget(context);
                  }),
                  Container(
                    color: ThemeColors.cf6f6f6,
                    padding: Insets.insetsWith(type: InsetsType.leftRight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Insets.top(margin: 50),
                        Row(
                          children: [
                            titleText("Nickname"),
                          ],
                        ),
                        Insets.top(margin: 12),
                        nameWidget(),
                        Insets.top(margin: 36),
                        Row(
                          children: [
                            titleText("Gender"),
                          ],
                        ),
                        Insets.top(margin: 12),
                        Obx(() => genderWidget()),
                        Insets.top(margin: 36),
                        Row(
                          children: [
                            titleText("About me"),
                          ],
                        ),
                        Insets.top(margin: 12),
                        aboutmeWidget(),
                        Insets.top(margin: 36),
                        // Row(
                        //   children: [
                        //     titleText("Videos"),
                        //   ],
                        // ),
                        // Insets.top(margin: 12),
                        // VerifiedVideosView(),
                      ],
                    ),
                  )
                ],
              )),
            ),
          ),
          color: ThemeColors.cddef00,
        ));
  }
}
