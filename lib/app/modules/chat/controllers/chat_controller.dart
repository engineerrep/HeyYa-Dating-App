import 'package:get/get.dart';
import 'package:heyya/app/modules/report/models/report_block_state.dart';
import 'package:tim_ui_kit/tim_ui_kit.dart';

class ChatController extends GetxController {
  //TODO: Implement ChatController

  late Rx<V2TimConversation> selectedConversation;
  late Worker _blockWorker;

  @override
  void onInit() {
    super.onInit();

    selectedConversation = (Get.arguments as V2TimConversation).obs;
  }

  @override
  void onReady() {
    super.onReady();
    //监听是否Block用户
    _blockWorker =
        ever(Get.find<ReportBlockState>().didBlockUserId, _onListenBlockUser);
  }

  void _onListenBlockUser(String blockedUserId) {
    Get.back();
  }

  @override
  void onClose() {
    _blockWorker.dispose();
    super.onClose();
  }
}
