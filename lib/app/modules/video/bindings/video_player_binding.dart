import 'package:get/get.dart';

import '../controllers/video_player_controller.dart';

class HeyVideoPlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HeyVideoPlayerController>(
      () => HeyVideoPlayerController(),
    );
  }
}
