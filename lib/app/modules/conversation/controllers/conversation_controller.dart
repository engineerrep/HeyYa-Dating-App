import 'package:get/get.dart';
import 'package:heyya/app/core/utils/app_manager.dart';
import 'package:heyya/app/core/utils/im_manager.dart';
import 'package:heyya/app/modules/report/models/report_block_state.dart';
import 'package:tim_ui_kit/data_services/conversation/conversation_services.dart';
import 'package:tim_ui_kit/data_services/services_locatar.dart';
import 'package:tim_ui_kit/ui/controller/tim_uikit_conversation_controller.dart';

class ConversationController extends GetxController {

  final TIMUIKitConversationController listController = TIMUIKitConversationController();
  late Worker _blockWorker;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    //监听是否Block用户
    _blockWorker =
        ever(Get.find<ReportBlockState>().didBlockUserId, _onListenBlockUser);
  }

  @override
  void onClose() {
    _blockWorker.dispose();
    super.onClose();
  }

  void _onListenBlockUser(String blockedUserId) {

    listController.deleteConversation(conversationID: 'c2c_' + ImManager.im_id_prefix + blockedUserId);
  }
}
