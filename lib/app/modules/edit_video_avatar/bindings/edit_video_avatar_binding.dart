import 'package:get/get.dart';

import '../controllers/edit_video_avatar_controller.dart';

class EditVideoAvatarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditVideoAvatarController>(
      () => EditVideoAvatarController(),
    );
  }
}
