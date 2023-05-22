// ignore_for_file: non_constant_identifier_names
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
        sdkAppID: im_sdkAppID,
        loglevel: LogLevelEnum.V2TIM_LOG_DEBUG,
        listener: V2TimSDKListener());
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
  }
}
