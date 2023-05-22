import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/utils/app_manager.dart';
import 'package:heyya/app/core/values/app_fonts.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import 'package:heyya/app/core/widget/placeholder_view.dart';
import 'package:heyya/app/modules/spark/views/spark_card_stack.dart';

import '../../../core/widget/custom_scaffold.dart';
import '../controllers/spark_controller.dart';

class SparkView extends GetView<SparkController> {
  const SparkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWithBackground(
      appBar: AppBar(
        title: ExtendedImage.asset(Assets.sparkTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: controller.obx(
        (_) => SparkCardStack(),
        onEmpty: PlaceholderView.sparkPlaceholder(
          callback: () {
            controller.loadNext(true);
          },
        ),
        onLoading: HeyyaLoadingIndicator(),
      ),
    );
  }
}
