import 'package:get/get.dart';
import '../controllers/video_topic_controller.dart';

class VideoTopicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoTopicController>(
      () => VideoTopicController(),
    );
  }
}
