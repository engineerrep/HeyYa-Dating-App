import 'package:flutter/material.dart';

import 'package:heyya/app/core/assets/flutter_assets.dart';
import 'package:extended_image/extended_image.dart';
import 'package:heyya/app/core/values/app_colors.dart';

import '../utils/inset_tool.dart';
import '../values/app_fonts.dart';

enum CustomButtonState {
  normal,
  disable,
  highlighted,
  selected,
}

class CustomButton extends StatelessWidget {
  CustomButtonState state;

  final String titleForNormal;
  final String? titleForDisable;
  final String? titleForSelected;
  final String? titleForHighlighed;
  final Color titleColorForNormal;
  final Color titleColorForDisable;
  final Color titleColorForHightlighted;
  final Color titleColorForSelected;
  final String backgroundImageForNormal;
  final String backgroundImageForDisable;
  final String backgroundImageForHighlighted;
  final String backgroundImageSelected;
  final double titleTopInset;
  final GestureTapUpCallback? onTapUp;
  final GestureTapDownCallback? onTapDown;
  final GestureTapCallback? onTap;
  final GestureTapCancelCallback? onTapCancel;

  Color titleColor() {
    switch (state) {
      case CustomButtonState.normal:
        return titleColorForNormal;
      case CustomButtonState.disable:
        return titleColorForDisable;
      case CustomButtonState.highlighted:
        return titleColorForHightlighted;
      case CustomButtonState.selected:
        return titleColorForSelected;
    }
  }

  String title() {
    switch (state) {
      case CustomButtonState.normal:
        return titleForNormal;
      case CustomButtonState.disable:
        return (titleForDisable ?? titleForNormal);
      case CustomButtonState.highlighted:
        return (titleForHighlighed ?? titleForNormal);
      case CustomButtonState.selected:
        return (titleForSelected ?? titleForNormal);
    }
  }

  String backgroundImage() {
    switch (state) {
      case CustomButtonState.normal:
        return backgroundImageForNormal;
      case CustomButtonState.disable:
        return backgroundImageForDisable;
      case CustomButtonState.highlighted:
        return backgroundImageForHighlighted;
      case CustomButtonState.selected:
        return backgroundImageSelected;
    }
  }

  static CustomButton editProfileButton(
      {String title = "Next",
      CustomButtonState state = CustomButtonState.disable,
      GestureTapCallback? onTap}) {
    return CustomButton(
      titleForNormal: title,
      titleTopInset: 39,
      state: state,
      titleColorForDisable: Colors.white,
      titleColorForNormal: ThemeColors.c272b00,
      backgroundImageForDisable: Assets.editButtonNormal,
      backgroundImageSelected: Assets.editButtonSelect,
      onTap: onTap,
    );
  }

  CustomButton(
      {super.key,
      required this.titleForNormal,
      this.state = CustomButtonState.normal,
      this.titleForDisable,
      this.titleForHighlighed,
      this.titleForSelected,
      this.titleColorForNormal = ThemeColors.cb5b5ac,
      this.titleColorForDisable = ThemeColors.cb5b5ac,
      this.titleColorForHightlighted = ThemeColors.c1f2320,
      this.titleColorForSelected = ThemeColors.c1f2320,
      this.backgroundImageForNormal = Assets.customButtonNormal,
      this.backgroundImageForDisable = Assets.customButtonNormal,
      this.backgroundImageSelected = Assets.customButtonSelect,
      this.backgroundImageForHighlighted = Assets.customButtonSelect,
      this.titleTopInset = 39,
      this.onTap,
      this.onTapCancel,
      this.onTapDown,
      this.onTapUp});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: state == CustomButtonState.selected ? onTapDown : null,
      onTapCancel: state == CustomButtonState.selected ? onTapCancel : null,
      onTap: state == CustomButtonState.selected ? onTap : null,
      onTapUp: state == CustomButtonState.selected ? onTapUp : null,
      child: Container(
        //color: Colors.red,
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child:
                    Container(child: ExtendedImage.asset(backgroundImage()))),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: Insets.insetsWith(
                      type: InsetsType.top, margin: titleTopInset),
                  child: Text(title(),
                      style: textStyle(
                          type: TextType.bold,
                          fontSize: 20,
                          color: titleColor())),
                )),
          ],
        ),
      ),
    );
  }
}
