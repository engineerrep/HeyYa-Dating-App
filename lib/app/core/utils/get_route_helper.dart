import 'package:get/get.dart';
import 'package:heyya/app/modules/tabbar/controllers/tabbar_controller.dart';
import 'package:heyya/app/routes/app_pages.dart';

abstract class GetRouteHelper {
  static backToRoot() {
    Get.until((route) {
      return !(route as GetPageRoute).canPop;
    });
  }

  static backTo({required String route}) {
    Get.until((route) {
      // ignore: unrelated_type_equality_checks
      return (Get.currentRoute == route);
    });
  }

  static backToTabbar() {
    Get.until((route) {
      return (Get.currentRoute == Routes.TABBAR);
    });
  }

  static backToSpark() {
    Get.until((route) {
      return (Get.currentRoute == Routes.TABBAR);
    });
    final tabController = Get.find<TabbarController>();
    tabController.cupertinoTabContoller.value.index = 0;
  }
}
