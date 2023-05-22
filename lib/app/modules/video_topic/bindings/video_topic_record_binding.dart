import 'package:get/get.dart';
import 'package:heyya/app/modules/video_topic/controllers/video_topic_record_controller.dart';

class VideoTopicRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VideoTopicRecordController());
    // Get.lazyPut<VideoTopicRecordController>(
    //   () => VideoTopicRecordController(),
    // );
  }
}
