import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/flutter_assets.dart';
import 'package:heyya/app/core/enum/gender_type.dart';
import 'package:heyya/app/core/utils/inset_tool.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/values/app_fonts.dart';
import 'package:heyya/app/core/widget/heyya_webview.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/routes/app_pages.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../core/widget/custom_scaffold.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);

  Widget itemCount(
      {required int count,
      required String title,
      GestureTapCallback? callBack}) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Text(
              "$count",
              style: textStyle(
                  type: TextType.regular,
                  color: ThemeColors.c1f2320,
                  fontSize: 16),
            ),
            Insets.top(margin: 8),
            Text(
              title,
              style: textStyle(
                  type: TextType.regular,
                  color: ThemeColors.c7f8a87,
                  fontSize: 12),
            )
          ],
        ),
        onTap: callBack);
  }

  Widget itemIconName(
      {required String icon,
      required String title,
      required bool isFeedback,
      GestureTapCallback? callBack}) {
    final widgets = [
      ExtendedImage.asset(icon),
      Insets.right(),
      Text(title,
          style: textStyle(
              type: TextType.regular,
              color: ThemeColors.c1f2320,
              fontSize: 12)),
    ];

    return GestureDetector(
      child: Container(
        color: Colors.white,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Row(
              children: widgets,
            ),
            isFeedback
                ? Align(
                    child: ExtendedImage.asset(Assets.imageAppreciated),
                    alignment: Alignment.topRight,
                  )
                : Container(),
          ],
        ),
      ),
      onTap: callBack,
    );
  }

  Widget myInfoWidget() {
    return Container(
      padding: Insets.insetsWith(type: InsetsType.leftRight),
      child: GetBuilder<ProfileController>(builder: (_) {
        return Row(
          children: [
            Container(
              child: avatarWidget(),
              width: 64,
              height: 64,
            ),
            Insets.right(margin: 16),
            Expanded(
                child: Text(
              Session.getUser()?.nickname ?? "",
              style: textStyle(
                  type: TextType.regular,
                  color: ThemeColors.c1f2320,
                  fontSize: 22),
            )),
            Insets.right(margin: 16),
            GestureDetector(
              child: Container(
                width: 48,
                height: 24,
                child: Center(
                  child: Text(
                    "Edit",
                    style: textStyle(
                        type: TextType.regular,
                        color: Colors.white,
                        fontSize: 12),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4)),
              ),
              onTap: () {
                controller.toEditProfile();
              },
            )
          ],
        );
      }),
    );
  }

  Widget relationWidget() {
    return Obx(() => Container(
            // color: Colors.yellow,
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            itemCount(
                count: Session.getRelation()?.myLikeNum ?? 0,
                title: "My likes",
                callBack: () {
                  Get.toNamed(Routes.MYLIKES);
                }),
            itemCount(
                count: Session.getRelation()?.likeMeNum ?? 0,
                title: "Like me",
                callBack: () {
                  Get.toNamed(Routes.LIKESME);
                }),
            itemCount(
                count: Session.getRelation()?.matchNum ?? 0,
                title: "Matched",
                callBack: () {
                  Get.toNamed(Routes.MATCHED);
                }),
            itemCount(
                count: Session.getRelation()?.visitorsNum ?? 0,
                title: "Visitors",
                callBack: () {
                  Get.toNamed(Routes.VISITORS);
                }),
          ],
        )));
  }

  Widget genderWidget() {
    final sex = Session.shard().user?.value.sex;
    if (sex == genderValue(GenderType.male)) {
      return ExtendedImage.asset(
        Assets.iconMale,
      );
    } else if (sex == genderValue(GenderType.female)) {
      return ExtendedImage.asset(
        Assets.iconFemale,
      );
    } else {
      return Container();
    }
  }

  Widget avatarWidget() {
    final avatar = Session.shard().user?.value.avatar;
    if (avatar != null && avatar.isNotEmpty) {
      return Stack(
          fit: StackFit.loose,
          alignment: Alignment.bottomRight,
          children: [
            Container(
              alignment: Alignment.center,
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Container(
                alignment: Alignment.center,
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: DecorationImage(
                      image: ExtendedImage.network(
                        avatar,
                      ).image,
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            genderWidget(),
          ]);
    } else {
      return Stack(alignment: Alignment.bottomRight, children: [
        Container(
          alignment: Alignment.center,
          width: 64,
          height: 64,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: ExtendedImage.asset(Assets.imageBgAvatar),
        ),
        genderWidget(),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWithBackground(
      appBar: CustomAppBar(
        backgroundColor: Colors.transparent,
        titleText: "",
        isBackButtonEnabled: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Insets.top(margin: 88),
              Container(height: 64, child: myInfoWidget()),
              Insets.top(margin: 24),
              Container(height: 45, child: relationWidget()),
              Insets.top(margin: 35),
              Container(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      itemIconName(
                          icon: Assets.myAddAccounts,
                          title: "Social Account",
                          isFeedback: false,
                          callBack: () {
                            controller.toContactInfo();
                          }),
                      Insets.top(margin: 24),
                      itemIconName(
                          icon: Assets.iconEdit,
                          title: "My Videos",
                          isFeedback: false,
                          callBack: () {
                            UserProfile.checkVideo(
                                controller.videoVerified, null);
                          }),
                      Insets.top(margin: 24),
                      itemIconName(
                          icon: Assets.iconFeedback,
                          title: "Feedback",
                          isFeedback: true,
                          callBack: () {
                            Get.toNamed(Routes.FEEDBACK);
                          }),
                      Insets.top(margin: 24),
                      itemIconName(
                          icon: Assets.iconBlockedlist,
                          title: "Blocked List",
                          isFeedback: false,
                          callBack: () {
                            Get.toNamed(Routes.BLOCK_LIST);
                          }),
                    ],
                  ),
                ),
                padding: Insets.insetsWith(type: InsetsType.leftRight),
              ),
              Insets.top(margin: 10),
              Container(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      itemIconName(
                          icon: Assets.iconSa,
                          title: HeyyaWebviewType.sa.toText(),
                          isFeedback: false,
                          callBack: () {
                            controller.toPP();
                          }),
                      Insets.top(margin: 24),
                      itemIconName(
                          icon: Assets.iconPp,
                          title: HeyyaWebviewType.pp.toText(),
                          isFeedback: false,
                          callBack: () {
                            controller.toSA();
                          }),
                    ],
                  ),
                ),
                padding: Insets.insetsWith(type: InsetsType.leftRight),
              ),
              Insets.top(margin: 10),
              Container(
                  padding: Insets.insetsWith(type: InsetsType.leftRight),
                  child: GestureDetector(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text("Sign Out",
                            style: textStyle(
                                type: TextType.regular,
                                color: ThemeColors.cf97fa8,
                                fontSize: 12)),
                      ),
                    ),
                    onTap: () {
                      controller.showSignOutAlert();
                    },
                  )),
              Insets.top(margin: 33),
              GestureDetector(
                child: Center(
                  child: Text("Delete Account",
                      style: textStyle(
                          type: TextType.regular,
                          color: ThemeColors.c7f8a87,
                          fontSize: 12)),
                ),
                onTap: () {
                  controller.showDeleteAccountAlert();
                },
              ),
              Insets.top(margin: 88),
            ],
          ),
        ),
      ),
    );
  }
}
