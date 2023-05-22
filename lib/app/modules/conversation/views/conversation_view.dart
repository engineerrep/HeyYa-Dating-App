import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/utils/get_route_helper.dart';
import 'package:heyya/app/core/utils/im_manager.dart';
import 'package:heyya/app/core/widget/placeholder_view.dart';
import 'package:heyya/app/routes/app_pages.dart';
import 'package:tim_ui_kit/data_services/conversation/conversation_services.dart';
import 'package:tim_ui_kit/data_services/services_locatar.dart';
import 'package:tim_ui_kit/ui/views/TIMUIKitConversation/tim_uikit_conversation.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../core/widget/custom_scaffold.dart';
import '../../chat/views/chat_view.dart';
import '../controllers/conversation_controller.dart';

class ConversationView extends GetView<ConversationController> {
  const ConversationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWithBackground(
      appBar: CustomAppBar(
        titleText: "Messages",
      ),
      body: SafeArea(child: conversation(context)),
    );
  }

  Widget conversation(BuildContext context) {
    return TIMUIKitConversation(
      controller: controller.listController,
      emptyBuilder: () {
        return Container(
          height: Get.height,
          alignment: Alignment.center,
          child: PlaceholderView.conversationPlaceholder(callback: () {
            GetRouteHelper.backToSpark();
          }),
        );
      },
      onTapItem: (selectedConv) {
        var id = selectedConv.userID;
        if (id != null) {
          // ImManager.shared
          //     .chatWithUser(userId: id, showName: selectedConv.showName);
          Get.toNamed(Routes.CHAT, arguments: selectedConv);
        }
      },
    );
  }
}
