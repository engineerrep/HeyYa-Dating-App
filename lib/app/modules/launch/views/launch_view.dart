import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets_images.dart';
import 'package:heyya/app/core/assets/flutter_assets.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/widget/heyya_container.dart';

import '../controllers/launch_controller.dart';

class LaunchView extends GetView<LaunchController> {
  const LaunchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LaunchView'),
        centerTitle: true,
      ),
      body: Container(
          child: Center(child: ExtendedImage(image: AssetImages.messagesImage)),
          color: ThemeColors.c1f2320),
    );
  }
}
