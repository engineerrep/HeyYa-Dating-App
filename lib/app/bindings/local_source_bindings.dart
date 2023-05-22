import 'package:get/get.dart';
import '../data/local/Storage/storage.dart';
import '../modules/report/models/report_block_state.dart';

class LocalSourceBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(HeyStorage());
    Get.put<ReportBlockState>(ReportBlockState());
  }
}
