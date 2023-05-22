import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/widget/custom_app_bar.dart';
import 'package:heyya/app/core/widget/custom_scaffold.dart';
import 'package:heyya/app/core/widget/heyya_webview.dart';

import '../controllers/pp_sa_controller.dart';

class PpSaView extends GetView<PpSaController> {
  PpSaView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: CustomAppBar(
          titleText: controller.webviewType.toText(),
          isBackButtonEnabled: true,
        ),
        body: Container(
          width: Get.width,
          height: Get.height,
          child: HeyyaWebview(type: controller.webviewType),
        ));
  }
}
