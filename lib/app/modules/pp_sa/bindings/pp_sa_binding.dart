import 'package:get/get.dart';

import '../controllers/pp_sa_controller.dart';

class PpSaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PpSaController>(
      () => PpSaController(),
    );
  }
}
