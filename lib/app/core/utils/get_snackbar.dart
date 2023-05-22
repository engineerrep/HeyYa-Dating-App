import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/assets/flutter_assets.dart';
import 'package:heyya/app/core/utils/inset_tool.dart';
import 'package:heyya/app/core/values/app_fonts.dart';

enum GetSnackbarType {
  success,
  failure,
  warning,
  notification,
}

class GetSnackbarTool {
  static Widget textWidget(String text) {
    return Text(
      text,
      style: textStyle(color: Colors.white, fontSize: 14),
    );
  }

  static Widget iconWidget(GetSnackbarType type) {
    switch (type) {
      case GetSnackbarType.success:
        return ExtendedImage.asset(Assets.tipSuccess);
      case GetSnackbarType.failure:
        return ExtendedImage.asset(Assets.tipFailure);
      case GetSnackbarType.warning:
        return ExtendedImage.asset(Assets.tipWarning);
      case GetSnackbarType.notification:
        return ExtendedImage.asset(Assets.tipNotification);
    }
  }

  static ImageProvider backgroundIconWidget(GetSnackbarType type) {
    switch (type) {
      case GetSnackbarType.success:
        return AssetImages.tipSuccessBg;
      case GetSnackbarType.failure:
        return AssetImages.tipFailureBg;
      case GetSnackbarType.warning:
        return AssetImages.tipWarningBg;
      case GetSnackbarType.notification:
        return AssetImages.tipNotificationBg;
    }
  }

  static showText(
      {required String text,
      required GetSnackbarType type,
      int duration = 1,
      bool instantInit = true,
      bool isDismissible = true}) {
    final double leftRightPad = 20;
    final width = Get.width - leftRightPad * 2;
    Get.snackbar("", "",
        barBlur: 0,
        isDismissible: isDismissible,
        instantInit: instantInit,
        backgroundColor: Colors.white.withAlpha(0),
        duration: Duration(seconds: duration),
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.fromLTRB(leftRightPad, 0, leftRightPad, 0),
        messageText: Container(
          decoration: BoxDecoration(color: Colors.yellow),
          width: width,
          height: 0,
        ),
        titleText: Container(
          width: width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: backgroundIconWidget(type),
                  fit: BoxFit.fill,
                  centerSlice: Rect.fromLTWH(130, 15, 10, 10))),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                iconWidget(type),
                Insets.right(margin: 8),
                Expanded(child: textWidget(text)),
              ],
            ),
          ),
        ));
  }
}
