import 'dart:math';
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:heyya/app/core/assets/flutter_assets.dart';
import 'package:heyya/app/core/enum/media_type.dart';
import 'package:heyya/app/core/extensions/UserEntity+Ext.dart';
import 'package:heyya/app/core/heyya_exports.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/widget/custom_app_bar.dart';
import 'package:heyya/app/core/widget/custom_scaffold.dart';
import 'package:heyya/app/data/model/user_entity.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/modules/user_profile/controllers/user_profile_controller.dart';
import 'package:heyya/app/modules/video_list/views/video_list_view.dart';
import 'package:heyya/app/routes/app_pages.dart';

class UserProfileView extends GetView<UserProfileController> {
  const UserProfileView({Key? key}) : super(key: key);

  _onMessage() {
    UserProfile.checkVideo(controller.onMessage, null);
  }

  _onLike() {
    final uid = controller.user?.value.id ?? "";
    UserProfile.checkVideo(controller.like, [uid]);
  }

  _onUnlike() {
    final uid = controller.user?.value.id ?? "";
    UserProfile.checkVideo(controller.unlike, [uid]);
  }

  topUserView() {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      if (index == 0) {
        return Stack(
          children: [
            mainVideo(),
            Positioned(
              left: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Container(
                  alignment: Alignment.center,
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      image: DecorationImage(
                        image: ExtendedImage.network(
                          controller.user?.value.avatar ?? "",
                        ).image,
                        fit: BoxFit.cover,
                      )),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 9,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ExtendedImage.asset(Assets.profileLess),
                ),
              ),
            ),
          ],
        );
      } else if (index == 1) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.user?.value.nickname ?? "In review",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                controller.user?.value.aboutMe ?? "In review",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        );
      }
      return Container();
    }, childCount: 2));
  }

  verifiedFunc() => Get.toNamed(Routes.VERIFIED_VIDEOS);

  Widget contactInfo(String title, String info, {VoidCallback? callback}) {
    UserEntity? userEntity = Session.getUser();

    return CupertinoButton(
      minSize: 28,
      pressedOpacity: 1.0,
      padding: EdgeInsets.zero,
      onPressed: callback ??
          () {
            if (!(userEntity?.hasMainVideo() ?? false)) {
              UserProfile.checkVideo(verifiedFunc, null);
              return;
            }

            if (info == 'Ask me') {
              _onMessage();
              return;
            }

            Clipboard.setData(ClipboardData(text: info));

            if (Get.isSnackbarOpen) return;

            HeySnackBar.showSuccess('Copied');
          },
      child: Text.rich(TextSpan(children: [
        TextSpan(text: title, style: textStyle(color: ThemeColors.c7f8a87)),
        WidgetSpan(
            child: Stack(
          children: [
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    info,
                    style: textStyle(color: ThemeColors.c272b00),
                    maxLines: 2,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  if (info != 'Ask me') Image.asset(Assets.profileCopy)
                ],
              ),
            ),
            if (!(userEntity?.hasMainVideo() ?? false))
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    child: Opacity(
                      opacity: 0.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            info,
                            style: textStyle(color: ThemeColors.c272b00),
                            maxLines: 2,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Image.asset(Assets.profileCopy)
                        ],
                      ),
                    ),
                  ),
                ),
              )
          ],
        ))
      ])),
    );
  }

  String generateRandomString(int length) {
    final _random = Random();
    const _availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length,
            (index) => _availableChars[_random.nextInt(_availableChars.length)])
        .join();

    return randomString;
  }

  Widget contactInfoWidget() {
    UserEntity? userEntity = Session.getUser();

    String phone = controller.user!.value.phone ?? 'Ask me';
    String email = controller.user!.value.email ?? 'Ask me';
    String instagram = controller.user!.value.instagram ?? 'Ask me';
    String snapchat = controller.user!.value.snapchat ?? 'Ask me';
    String tiktok = controller.user!.value.tiktok ?? 'Ask me';

    if (userEntity?.hasMainVideo() ?? false) {
      if (phone == '') phone = 'Ask me';
      if (email == '') email = 'Ask me';
      if (instagram == '') instagram = 'Ask me';
      if (snapchat == '') snapchat = 'Ask me';
      if (tiktok == '') tiktok = 'Ask me';
    } else {
      if (phone == '')
        phone = "${generateRandomString(Random().nextInt(8) + 8)}";
      if (email == '')
        email = "${generateRandomString(Random().nextInt(8) + 8)}";
      if (instagram == '')
        instagram = "${generateRandomString(Random().nextInt(8) + 8)}";
      if (snapchat == '')
        snapchat = "${generateRandomString(Random().nextInt(8) + 8)}";
      if (tiktok == '')
        tiktok = "${generateRandomString(Random().nextInt(8) + 8)}";
    }

    return SliverPadding(
      padding: const EdgeInsets.only(
          left: horizontalPadding, right: horizontalPadding, bottom: 15),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Social Account',
                style: textStyle(
                    fontSize: 18,
                    type: TextType.bold,
                    color: ThemeColors.c1f2320),
              ),
            ),
            contactInfo('Phone: ', phone),
            contactInfo('Email: ', email),
            contactInfo('Instagram: ', instagram),
            contactInfo('Snapchat: ', snapchat),
            contactInfo('Tiktok: ', tiktok),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Text(
                'Videos',
                style: textStyle(
                    fontSize: 18,
                    type: TextType.bold,
                    color: ThemeColors.c1f2320),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget videosSliver() {
    final medias = controller.user?.value.medias
        ?.where((element) =>
            element.type == MediaType.MAIN_VIDEO ||
            element.type == MediaType.VERIFY_VIDEO)
        .toList();
    final double bottomOffset = (medias?.length ?? 0) > 0 ? 152 : 0;
    return SliverPadding(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: bottomOffset),
      sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate((context, index) {
            final media = controller.user?.value.medias?[index];
            final cover = media?.cover;
            final avatar = controller.user?.value.avatar;

            String image;
            if (cover != null && cover.isNotEmpty) {
              image = cover;
            } else {
              image = avatar ?? "";
            }
            return CupertinoButton(
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.zero,
                pressedOpacity: 0.9,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: ExtendedImage.network(image).image,
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.zero),
                  child: Image.asset(Assets.verifyvideoPause),
                ),
                onPressed: () {
                  final media = controller.user?.value.medias?[index];
                  Get.toNamed(Routes.VIDEO_PLAYER, arguments: media);
                });
          }, childCount: controller.user?.value.medias?.length ?? 0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 114.0 / 152.0)),
    );
  }

  Widget passContainer() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
          onTap: _onUnlike, child: ExtendedImage.asset(Assets.sparkPass)),
    );
  }

  Widget messageContainer(bool likeOrPassed) {
    final double bottom = (likeOrPassed ? 20 : 40);
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0, bottom: bottom, top: 20),
      child: GestureDetector(
          onTap: () => _onMessage(),
          child: ExtendedImage.asset(Assets.sparkMessage)),
    );
  }

  Widget likeContainer(bool likeOrPassed) {
    final liked = controller.user?.value.liked ?? false;
    final matched = controller.user?.value.matchd ?? false;
    final likeAssets = likeOrPassed
        ? (liked || matched ? Assets.profileLiked : Assets.profileLike)
        : Assets.sparkLike;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: _onLike,
        child: Container(
          child: ExtendedImage.asset(
            likeAssets,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  List<Widget> bottomActionContainer() {
    final matched = controller.user?.value.matchd ?? false;
    final liked = controller.user?.value.liked ?? false;
    final passed = controller.user?.value.passed ?? false;
    if (!liked && !passed && !matched) {
      return [passContainer(), messageContainer(false), likeContainer(false)];
    } else {
      return [messageContainer(true), likeContainer(true)];
    }
  }

  Widget bottomToolView() {
    if (controller.user?.value.isCurrentUser() ?? false) {
      return Container();
    } else {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: bottomActionContainer(),
        ),
      );
    }
  }

  Widget mainVideo() {
    final avatar = controller.user?.value.avatar;
    final videos = controller.user?.value.medias
        ?.where((element) => element.type == MediaType.MAIN_VIDEO)
        .toList();
    var main;
    if (videos != null && videos.length > 0) {
      main = videos.first;
    }
    final cover = main?.cover;
    if (main != null) {
      final String image;
      if (cover != null && cover.isNotEmpty) {
        image = cover;
      } else {
        image = avatar ?? "";
      }
      return CupertinoButton(
          padding: EdgeInsets.zero,
          child: Container(
              padding: const EdgeInsets.only(bottom: 35),
              width: double.infinity,
              height: Get.width * 502.0 / 375.0 + 35,
              child: Container(
                width: double.infinity,
                height: Get.width * 502.0 / 375.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExtendedImage.network(
                      image,
                    ).image,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Image.asset(Assets.sparkPause),
              )),
          onPressed: () {
            Get.toNamed(Routes.VIDEO_PLAYER, arguments: main);
          });
    } else if (avatar != null) {
      return CupertinoButton(
          padding: EdgeInsets.zero,
          child: Container(
              padding: const EdgeInsets.only(bottom: 35),
              width: double.infinity,
              height: Get.width * 502.0 / 375.0 + 35,
              child: Container(
                width: double.infinity,
                height: Get.width * 502.0 / 375.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExtendedImage.network(
                      avatar,
                    ).image,
                    fit: BoxFit.cover,
                  ),
                ),
                child: null,
              )),
          onPressed: () {});
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWithBackground(
      appBar: CustomAppBar(
        backgroundColor: Colors.transparent,
        titleText: "",
        isBackButtonEnabled: false,
      ),
      body: WillPopScope(
        onWillPop: () async {
          //禁止滑动返回
          return true;
        },
        child: GetBuilder<UserProfileController>(builder: (_) {
          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  topUserView(),
                  contactInfoWidget(),
                  videosSliver(),
                ],
              ),
              bottomToolView(),
            ],
          );
        }),
      ),
    );
  }
}
