import 'dart:math';

import 'package:flutter/material.dart';

abstract class ThemeColors {
  static const Color c1f2320 = Color(0xFF1F2320);
  static const Color c272b00 = Color(0xFF272B00);
  static const Color c7f8a87 = Color(0xFF7F8A87);
  static const Color cddef00 = Color(0xFFDDEF00);
  static const Color cf2f5f4 = Color(0xFFF2F5F4);
  static const Color c00ffbf = Color(0xFF00FFBF);
  static const Color c47b2f9 = Color(0xFF47B2F9);
  static const Color cf97fa8 = Color(0xFFF97FA8);
  static const Color c88a7ff = Color(0xFF88A7FF);
  static const Color cb5b5ac = Color(0xFFB5B5AC);
  static const Color cfe4281 = Color(0xFFFE4281);
  static const Color cf6f6f6 = Color(0xFFF6F6F6);

  static const Spark_title_colors = [
    ThemeColors.cddef00,
    ThemeColors.c00ffbf,
    ThemeColors.c47b2f9,
    ThemeColors.cf97fa8,
    ThemeColors.c88a7ff
  ];
  static Color randomSparkTitleColor() {
    final index =
        Random.secure().nextInt(ThemeColors.Spark_title_colors.length);
    return ThemeColors.Spark_title_colors.elementAt(index);
  }
}

abstract class AppColors {
  static const Color pageBackground = Color(0xFFFAFBFD);
  static const Color statusBarColor = Color(0xFF38686A);
  static const Color appBarColor = Color(0xFF38686A);
  static const Color appBarIconColor = Color(0xFFFFFFFF);
  static const Color appBarTextColor = Color(0xFFFFFFFF);

  static const Color centerTextColor = Colors.grey;
  static const MaterialColor colorPrimarySwatch = Colors.cyan;
  static const Color colorPrimary = Color(0xFF38686A);
  static const Color colorAccent = Color(0xFF38686A);
  static const Color colorLightGreen = Color(0xFF00EFA7);
  static const Color colorWhite = Color(0xFFFFFFFF);
  static const Color lightGreyColor = Color(0xFFC4C4C4);
  static const Color errorColor = Color(0xFFAB0B0B);
  static const Color colorDark = Color(0xFF323232);

  static const Color buttonBgColor = colorPrimary;
  static const Color disabledButtonBgColor = Color(0xFFBFBFC0);
  static const Color defaultRippleColor = Color(0x0338686A);

  static const Color gray = Color(0xFF323232);
  static const Color lightGray = Color(0xFF9FA4B0);
  static const Color black = colorPrimary;
  static const Color lightBlack = Color(0xFFABABAB);

  static const Color textColorPrimary = Color(0xFF323232);
  static const Color textColorSecondary = Color(0xFF9FA4B0);
  static const Color textColorTag = colorPrimary;
  static const Color textColorGreyLight = Color(0xFFABABAB);
  static const Color textColorGreyDark = Color(0xFF979797);
  static const Color textColorBlueGreyDark = Color(0xFF939699);
  static const Color textColorCyan = Color(0xFF38686A);
  static const Color textColorWhite = Color(0xFFFFFFFF);
  static Color searchFieldTextColor = const Color(0xFF323232).withOpacity(0.5);

  static const Color iconColorDefault = Colors.grey;

  static Color barrierColor = const Color(0xFF000000).withOpacity(0.5);

  static Color timelineDividerColor = const Color(0x5438686A);

  static const Color gradientStartColor = Colors.black87;
  static const Color gradientEndColor = Colors.transparent;
  static const Color silverAppBarOverlayColor = Color(0x80323232);

  static const Color switchActiveColor = colorPrimary;
  static const Color switchInactiveColor = Color(0xFFABABAB);
  static Color elevatedContainerColorOpacity = Colors.grey.withOpacity(0.5);
  static const Color suffixImageColor = Colors.grey;
}
