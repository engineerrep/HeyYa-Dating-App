import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/flutter_assets.dart';
import 'package:heyya/app/core/utils/inset_tool.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/values/app_fonts.dart';

class GetBottomAlert {
  static showCompleteVideoAlert(
      {VoidCallback? doneCallback, VoidCallback? cancelCallback}) {
    final title = "Welcome to Heyya!";
    final content =
        "All members are required to get video authenticated so we can keep our community safe. Please complete the video certification to contact other singles.";
    showAction(
        provider: AssetImages.imageVerifyVideo,
        title: title,
        content: content,
        doneTitle: "Verify Now",
        cancelTitle: "Maybe Later",
        doneCallback: doneCallback,
        cancelCallback: cancelCallback);
  }

  static showCompleteProfileAlert(
      {VoidCallback? doneCallback, VoidCallback? cancelCallback}) {
    showAction(
        provider: AssetImages.imageCompleteProfile,
        title: "Complete Profile",
        content: "Help other users get to know you",
        doneTitle: "Complete Profile",
        cancelTitle: "Maybe Later",
        doneCallback: doneCallback,
        cancelCallback: cancelCallback);
  }

  static showBlockAlert(
      {VoidCallback? doneCallback, VoidCallback? cancelCallback}) {
    showAction(
        provider: AssetImages.imageBlock,
        title: "Block",
        content: "Are you sure to block this user?",
        doneTitle: "CANCEL",
        cancelTitle: "BLOCK",
        doneCallback: doneCallback,
        cancelCallback: cancelCallback);
  }

  static showPermissionAlert(
      {required VoidCallback doneCallback, required String content}) {
    showAction(
        provider: AssetImages.imageBlock,
        title: "Permission",
        content: content,
        doneTitle: "SETTINGS",
        cancelTitle: "CANCEL",
        doneCallback: () {
          Get.back();
          doneCallback();
        },
        cancelCallback: () => Get.back());
  }

  static showLogoutAlert(
      {VoidCallback? doneCallback, VoidCallback? cancelCallback}) {
    showAction(
        provider: AssetImages.imageLogOut,
        title: "Sign Out",
        content:
            "Are you sure you want to sign out? You will not receive messages after signed out.",
        doneTitle: "STAY",
        cancelTitle: "SIGN OUT",
        doneCallback: doneCallback,
        cancelCallback: cancelCallback);
  }

  static showDeleteAccountAlert(
      {VoidCallback? doneCallback, VoidCallback? cancelCallback}) {
    showAction(
        provider: AssetImages.imageDeleteAccount,
        title: "Delete Account",
        content:
            "No take backs! Choosing to delete your account is permanent and your information will immediately be removed.",
        doneTitle: "NO",
        cancelTitle: "YES",
        doneCallback: doneCallback,
        cancelCallback: cancelCallback);
  }

  static showDeleteMomentAlert(
      {VoidCallback? doneCallback, VoidCallback? cancelCallback}) {
    showAction(
        provider: AssetImages.imageDeleteAccount,
        title: "Delete This Moment",
        content: "Are you sure you want to delete this moment?",
        doneTitle: "NO",
        cancelTitle: "YES",
        doneCallback: doneCallback,
        cancelCallback: cancelCallback);
  }

  static showDeleteVideoAlert(
      {VoidCallback? doneCallback, VoidCallback? cancelCallback}) {
    showAction(
        provider: AssetImages.imageDeleteAccount,
        title: "Delete This Video",
        content: "Are you sure you want to delete this video?",
        doneTitle: "NO",
        cancelTitle: "YES",
        doneCallback: doneCallback,
        cancelCallback: cancelCallback);
  }

  static showAction({
    required ImageProvider provider,
    required String title,
    required String content,
    String doneTitle = "Done",
    String cancelTitle = "Cancel",
    VoidCallback? doneCallback,
    VoidCallback? cancelCallback,
  }) {
    Get.bottomSheet(
        _container(
            provider: provider,
            title: title,
            content: content,
            doneTitle: doneTitle,
            cancelTitle: cancelTitle,
            doneCallback: doneCallback,
            cancelCallback: cancelCallback),
        isScrollControlled: true,
        ignoreSafeArea: true,
        useRootNavigator: true);
  }

  static Widget _actionRow({
    String doneTitle = "Done",
    String cancelTitle = "Cancel",
    VoidCallback? doneCallback,
    VoidCallback? cancelCallback,
  }) {
    if (cancelTitle == "") {
      return Row(
        children: [
          Expanded(
              child: SizedBox(
            height: 40,
            child: CupertinoButton(
                padding: EdgeInsets.zero,
                color: Colors.black,
                child: Text(
                  doneTitle,
                  style: textStyle(
                      fontSize: 14,
                      color: Colors.white,
                      type: TextType.regular),
                ),
                onPressed: () {
                  if (doneCallback != null) {
                    doneCallback();
                  }
                }),
          )),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
              flex: 2,
              child: SizedBox(
                height: 40,
                child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    color: Colors.black,
                    child: Text(
                      doneTitle,
                      style: textStyle(
                          fontSize: 14,
                          color: Colors.white,
                          type: TextType.regular),
                    ),
                    onPressed: () {
                      if (doneCallback != null) {
                        doneCallback();
                      }
                    }),
              )),
          Expanded(
            flex: 1,
            child: SizedBox(
                child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(
                      cancelTitle,
                      style: textStyle(
                          fontSize: 14,
                          color: ThemeColors.c272b00,
                          type: TextType.regular),
                    ),
                    onPressed: () {
                      if (cancelCallback != null) {
                        cancelCallback();
                      }
                    })),
          ),
        ],
      );
    }
  }

  static Widget _container({
    required ImageProvider provider,
    required String title,
    required String content,
    String doneTitle = "Done",
    String cancelTitle = "Cancel",
    VoidCallback? doneCallback,
    VoidCallback? cancelCallback,
  }) {
    return Container(
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Insets.bottom(margin: 8),
            ExtendedImage(
              image: provider,
              fit: BoxFit.cover,
            ),
            Insets.bottom(margin: 20),
            Container(
                padding:
                    Insets.insetsWith(type: InsetsType.leftRight, margin: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(title,
                        style: textStyle(
                            color: ThemeColors.c272b00,
                            type: TextType.bold,
                            fontSize: 24)),
                    Insets.bottom(margin: 5),
                    Text(content,
                        textAlign: TextAlign.center,
                        style: textStyle(
                            color: ThemeColors.c7f8a87,
                            type: TextType.regular,
                            fontSize: 14)),
                    Insets.bottom(margin: 24),
                    _actionRow(
                        doneTitle: doneTitle,
                        cancelTitle: cancelTitle,
                        doneCallback: doneCallback,
                        cancelCallback: cancelCallback),
                    Insets.bottom(margin: 33),
                  ],
                ))
          ],
        ));
  }
}
