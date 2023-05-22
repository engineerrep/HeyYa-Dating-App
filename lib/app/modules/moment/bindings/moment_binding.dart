import 'package:get/get.dart';

import '../controllers/moment_controller.dart';

class MomentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MomentController>(
      () => MomentController(),
    );
  }
}
