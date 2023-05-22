import 'package:flutter/material.dart';

class Insets {
  static Widget bottom({double margin = 16}) {
    return Container(
        padding: Insets.insetsWith(type: InsetsType.bottom, margin: margin));
  }

  static Widget top({double margin = 16}) {
    return Container(
        padding: Insets.insetsWith(type: InsetsType.top, margin: margin));
  }

  static Widget left(int i, {double margin = 16}) {
    return Container(
        padding: Insets.insetsWith(type: InsetsType.left, margin: margin));
  }

  static Widget right({double margin = 16}) {
    return Container(
        padding: Insets.insetsWith(type: InsetsType.right, margin: margin));
  }

  static Widget getInsets({required InsetsType type, double margin = 16}) {
    return Container(padding: Insets.insetsWith(type: type, margin: margin));
  }

  static EdgeInsets insetsWith({required InsetsType type, double margin = 16}) {
    switch (type) {
      case InsetsType.left:
        return EdgeInsets.only(left: margin);
      case InsetsType.right:
        return EdgeInsets.only(right: margin);
      case InsetsType.top:
        return EdgeInsets.only(top: margin);
      case InsetsType.bottom:
        return EdgeInsets.only(bottom: margin);
      case InsetsType.leftRight:
        return EdgeInsets.only(left: margin, right: margin);
      case InsetsType.topBottom:
        return EdgeInsets.only(top: margin, bottom: margin);
      case InsetsType.all:
        return EdgeInsets.all(margin);
    }
  }
}

//边距
enum InsetsType {
  left,
  right,
  top,
  bottom,
  leftRight,
  topBottom,
  all,
}
