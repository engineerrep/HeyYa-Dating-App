import 'package:get/get.dart';
import 'package:heyya/app/modules/video/controllers/video_guiding_controller.dart';


class VideoGuidingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VideoGuidingController());
  }
}
