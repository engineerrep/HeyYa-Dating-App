import 'package:flutter/material.dart';


class HeyContainer extends StatelessWidget {
  HeyContainer(
      {this.alignment,this.clipBehavior = Clip.none, this.padding, this.width = 0, this.height = 0, this.bgImgPath, this.radius, this.bgColor, this.child});
  Clip clipBehavior;
  EdgeInsetsGeometry? padding;
   AlignmentGeometry? alignment;
  double width;
  double height;
  Widget? child;
  String? bgImgPath;
  double? radius;
  Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: clipBehavior,
      padding: padding,
      alignment: alignment,
      child: child,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor ?? null,
        image: bgImgPath == null
            ? null
            : DecorationImage(image: AssetImage(bgImgPath!), fit: BoxFit.fill),
        borderRadius:
            radius == null ? null : BorderRadius.all(Radius.circular(radius!)),
      ),
    );
  }
}
