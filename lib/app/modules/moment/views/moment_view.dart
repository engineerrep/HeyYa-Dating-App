import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyya/app/core/widget/custom_app_bar.dart';
import 'package:heyya/app/core/widget/custom_scaffold.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import 'package:heyya/app/core/widget/placeholder_view.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/modules/moment/controllers/moment_controller.dart';
import 'package:heyya/app/modules/moment/views/moment_list_view.dart';
import 'package:heyya/app/routes/app_pages.dart';

class MomentView extends GetView<MomentController> {
  const MomentView({Key? key}) : super(key: key);

  _onPost() {
    if (UserProfile.completeVideoIfNeeded(true) == false) {
      Get.toNamed(Routes.MOMENT_POST);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWithBackground(
      appBar: CustomAppBar(
        titleText: "Moments",
        isBackButtonEnabled: true,
      ),
      body: controller.obx(
        (_) => MomentListView(),
        onEmpty: PlaceholderView.momentPlaceholder(
          callback: _onPost,
        ),
        onLoading: const HeyyaLoadingIndicator(),
      ),
    );
  }
}
