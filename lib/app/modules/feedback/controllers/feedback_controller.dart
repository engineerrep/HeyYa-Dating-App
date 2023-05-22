import 'package:get/get.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/widget/heyya_assets_picker_builder.dart';
import 'package:heyya/app/data/repository/report_block_repository.dart';
import 'package:heyya/app/network/exceptions/base_exception.dart';

class FeedbackController extends GetxController {
  //TODO: Implement FeedbackController

  final feedbackRepository = ReportBlockRepository();
  final assetsController = HeyyaAssetsPickerController();

  RxString content = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<bool> feedback() async {
    try {
      if (assetsController.photos.length > 0) {
        var medias = await assetsController.uploadAssets();
        await feedbackRepository.feedback(
            content: content.value, medias: medias);
      } else {
        await feedbackRepository.feedback(content: content.value);
      }
      return true;
    } catch (e) {
      var msg = e is BaseException ? e.message : e.toString();
      HeySnackBar.showError(msg);
      return false;
    }
  }
}
