import 'package:get/get.dart';
import 'package:heyya/app/core/widget/heyya_assets_picker_builder.dart';

import '../controllers/moment_post_controller.dart';

class MomentPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MomentPostController>(
      () => MomentPostController(),
    );
    Get.lazyPut<HeyyaAssetsPickerController>(
        () => HeyyaAssetsPickerController());
  }
}
