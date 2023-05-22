import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../assets/assets.dart';

class CommonBackground extends StatelessWidget {
  final String asset;

  const CommonBackground({super.key, this.asset = Assets.commonBg});
  @override
  Widget build(BuildContext context) {
    return ExtendedImage.asset(
      asset,
      fit: BoxFit.cover,
      width: Get.width,
      height: Get.height,
    );
  }
}

class SafeBackground extends StatelessWidget {
  final String asset;

  const SafeBackground({super.key, this.asset = Assets.commonBg});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ExtendedImage.asset(
      asset,
      fit: BoxFit.cover,
      width: Get.width,
      height: Get.height,
    ));
  }
}
