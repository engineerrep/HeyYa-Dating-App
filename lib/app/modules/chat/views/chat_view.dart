import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:heyya/app/core/assets/assets.dart';
import 'package:heyya/app/core/utils/get_bottom_sheet.dart';
import 'package:heyya/app/core/values/app_colors.dart';
import 'package:heyya/app/core/values/app_fonts.dart';
import 'package:heyya/app/data/model/user_entity.dart';
import 'package:heyya/app/routes/app_pages.dart';
import 'package:heyya/generated/json/user_entity.g.dart';
import 'package:tim_ui_kit/tim_ui_kit.dart';
// import 'package:tim_ui_kit/ui/views/TIMUIKitChat/tim_uikit_chat.dart';

import '../controllers/chat_controller.dart';
import 'package:heyya/app/modules/spark/views/spark_card_stack.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);

  String? _getConvID() {
    return controller.selectedConversation.value.type == 1
        ? controller.selectedConversation.value.userID
        : controller.selectedConversation.value.groupID;
  }

  String? _pureConvID() {
    final prefix = "heyya_";
    final pureId = _getConvID()?.substring(prefix.length);
    return pureId;
  }

  @override
  Widget build(BuildContext context) {
    return TIMUIKitChat(
      appBarConfig: AppBar(
        title: GestureDetector(
          onTap: () {
            Get.toNamed(Routes.USER_PROFILE,
                arguments: $UserEntityFromJson({"id": _pureConvID()}));
          },
          child: Text(
            controller.selectedConversation.value.showName ?? "",
            style: textStyle(
                color: ThemeColors.c1f2320, fontSize: 20, type: TextType.bold),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => GetBottomSheet.showHeyyaReprt(userId: _pureConvID()!),
            child: ExtendedImage.asset(Assets.momentsMore),
          )
        ],
      ),
      config: TIMUIKitChatConfig(
        isAllowEmojiPanel: false,
        isAllowSoundMessage: false,
        isAllowShowMorePanel: false,
        isShowSelfNameInGroup: true,
      ),
      conversationID: _getConvID() ?? '',
      // groupID 或者 UserID
      conversationType: controller.selectedConversation.value.type ?? 0,
      // 会话类型
      conversationShowName:
          controller.selectedConversation.value.showName ?? "",
      // 会话展示名称
      onTapAvatar: (_) {}, // 点击消息发送者头像回调事件、可与 TIMUIKitProfile 关联使用
      // appBarActions: [
      //   IconButton(
      //       onPressed: () {}, icon: const Icon(Icons.more_horiz_outlined))
      // ],
    );
  }
}
