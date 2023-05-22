import 'package:get/get.dart';
import '../controllers/tabbar_controller.dart';

class TabbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabbarController>(
      () => TabbarController(),
    );
  }
}
