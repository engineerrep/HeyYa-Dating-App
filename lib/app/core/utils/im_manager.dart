import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/routes/app_pages.dart';
import 'package:heyya/config.dart';

import 'package:tim_ui_kit/tim_ui_kit.dart';

class ImManager {
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();

  static String im_id_prefix = 'heyya_';

  static ImManager? _instance;

  static ImManager get shared {
    if (_instance == null) {
      _instance = ImManager();
    }
    return _instance!;
  }

  Future<bool?> initSdk() async {
    return _coreInstance.init(
        sdkAppID: im_sdkAppID, // 控制台申请的 SDKAppID
        loglevel: LogLevelEnum.V2TIM_LOG_DEBUG,
        //   //TODO: jackson, 监听账号状态
        listener: V2TimSDKListener());

    // @Deprecated
    // TencentImSDKPlugin.v2TIMManager.initSDK(
    //   sdkAppID: 1400621113,
    //   loglevel: BuildConfig.instance.environment == Environment.DEVELOPMENT ? LogLevelEnum.V2TIM_LOG_DEBUG : LogLevelEnum.V2TIM_LOG_NONE, // Log
    //

    //   listener: V2TimSDKListener(),
    // );
  }

  signOut() {
    TencentImSDKPlugin.v2TIMManager.logout();
  }

  Future<bool> login(String userID, String userSig) async {
    V2TimCallback res = await TencentImSDKPlugin.v2TIMManager.login(
      userID: im_id_prefix + userID,
      userSig: userSig,
    );
    if (res.code != 0) {
      HeySnackBar.showError(res.desc);
    }
    return res.code == 0;
  }

  chatWithUser({required String userId, String? showName}) async {
    final conversationID = "c2c_" + im_id_prefix + userId;
    final conversation = V2TimConversation(
        showName: showName,
        conversationID: conversationID,
        type: 1,
        userID: im_id_prefix + userId);
    Get.toNamed(Routes.CHAT, arguments: conversation);

    // await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => Chat(
    //         selectedConversation: selectedConv!,
    //       ),
    //     ));
    // _controller.reloadData();
  }
}
