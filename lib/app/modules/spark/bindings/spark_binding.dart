import 'package:get/get.dart';

import '../controllers/spark_controller.dart';

class SparkBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SparkController());
  }
}
