import 'package:get/get.dart';
import '../controllers/verified_videos_controller.dart';

class VerifiedVideosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifiedVideosController>(
      () => VerifiedVideosController(),
    );
  }
}
