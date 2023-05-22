import 'package:get/get.dart';
import 'package:heyya/app/core/enum/report_type.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/widget/heyya_assets_picker_builder.dart';
import 'package:heyya/app/data/repository/report_block_repository.dart';
import 'package:heyya/app/modules/report/models/report_block_state.dart';
import 'package:heyya/app/network/exceptions/base_exception.dart';

class ReportController extends GetxController {
  final assetsController = HeyyaAssetsPickerController();
  final RxList<ReportType> selectedItems = RxList<ReportType>();
  RxString content = "".obs;
  final reportRepository = ReportBlockRepository();

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

  Future<bool> report() async {
    try {
      var toUserId = Get.find<ReportBlockState>().willReportUserId;
      // ignore: invalid_use_of_protected_member
      final type = selectedItems.value.first.toValue();
      if (toUserId != null) {
        if (assetsController.photos.length > 0) {
          var medias = await assetsController.uploadAssets();
          await reportRepository.reportUser(
              toUserId: toUserId,
              type: type,
              content: content.value,
              medias: medias);
        } else {
          await reportRepository.reportUser(
              toUserId: toUserId, type: type, content: content.value);
        }
        Get.find<ReportBlockState>().didFinishReport();
        return true;
      } else {
        HeySnackBar.showError("ReportBlockState user is null");
        return false;
      }
    } catch (e) {
      var msg = e is BaseException ? e.message : e.toString();
      HeySnackBar.showError(msg);
      return false;
    }
  }
}
