import 'package:flutter/material.dart';
import 'package:heyya/app/core/values/app_colors.dart';

TextStyle textStyle(
    {double fontSize = 16,
    Color color = ThemeColors.c1f2320,
    TextType type = TextType.regular,
    TextDecoration decoration = TextDecoration.none}) {
  return TextStyle(
      decoration: decoration,
      // decorationStyle: TextDecorationStyle.solid,
      fontFamily: fontFamily(type: type),
      fontSize: fontSize,
      color: color,
      // letterSpacing:0.2 * fontSize,
      fontWeight: fontWeight(type: type),
      fontStyle: fontStyle(type: type));
}

FontStyle fontStyle({required TextType type}) {
  switch (type) {
    case TextType.bold:
      return FontStyle.normal;
    case TextType.regular:
      return FontStyle.normal;
  }
}

String fontFamily({required TextType type}) {
  switch (type) {
    case TextType.bold:
      return "SinhalaMN-Bold";
    case TextType.regular:
      return "SinhalaMN";
  }
}

FontWeight fontWeight({required TextType type}) {
  switch (type) {
    case TextType.bold:
      return FontWeight.w700;
    case TextType.regular:
      return FontWeight.w400;
  }
}

enum TextType {
  bold,
  regular,
}
