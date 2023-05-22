import 'package:get/get.dart';


import '../controllers/video_record_controller.dart';

class VideoRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VideoRecordController());
  }
}
