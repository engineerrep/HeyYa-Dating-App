import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';

import 'package:heyya/app/modules/video/controllers/video_guiding_controller.dart';
import 'package:heyya/app/modules/video/controllers/video_record_controller.dart';

import '../controllers/sign_controller.dart';

class SignBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SignController());
  }
}
