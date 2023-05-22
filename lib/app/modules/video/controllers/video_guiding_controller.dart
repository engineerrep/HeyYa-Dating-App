import 'package:get/get.dart';
import 'package:heyya/app/core/utils/app_manager.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/modules/video/models/video_preview_model.dart';
import 'package:heyya/app/routes/app_pages.dart';

class VideoGuidingController extends GetxController {
  VideoPreviewModel? videoPreviewModel;

  @override
  void onInit() {
    super.onInit();
    videoPreviewModel = Get.arguments as VideoPreviewModel?;
  }

  toSignin() {
    Get.toNamed(Routes.VIDEO_RECORD, arguments: videoPreviewModel);
    UserProfile.completeProfileIfNeeded(needed: true, showAlert: false);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
