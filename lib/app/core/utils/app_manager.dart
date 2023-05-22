import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:heyya/app/core/enum/device.dart';
import 'package:heyya/app/core/enum/media_type.dart';
import 'package:heyya/app/core/utils/get_bottom_alert.dart';
import 'package:heyya/app/core/utils/im_manager.dart';
import 'package:heyya/app/data/local/Storage/storage.dart';
import 'package:heyya/app/data/model/media_entity.dart';
import 'package:heyya/app/data/model/user_entity.dart';
import 'package:heyya/app/data/repository/relation_repository.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/routes/app_pages.dart';
import 'package:heyya/firebase_options.dart';

import '../../data/repository/user_repository.dart';
import 'package:permission_handler/permission_handler.dart';

GoogleSignIn googleSignInInstance = GoogleSignIn(
    // scopes: <String>[
    //   'email',
    //   'https://www.googleapis.com/auth/contacts.readonly',
    // ],
    );

class AppManager {
  static final shared = AppManager();

  /// 初始化应用
  static Future<bool?> initialApp() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await GetStorage.init();
    await ImManager.shared.initSdk();
  }

  /// 用户登录成功以后初始化操作
  static initialLogin() async {
    UserEntity? user = Get.find<HeyStorage>().getUser()!;

    /// 登录im
    var userSig = Get.find<HeyStorage>().getSig();
    await ImManager.shared.login(user.id!.toString(), userSig);
    updateCurrentUserProfile();
    updateRelationNum();
  }

  /// permission
  Future<bool> checkPermission(List<Permission> permissions,
      {required String tipContent}) async {
    var resps = await permissions.request();
    bool isGranted =
        resps.values.where((element) => element.isGranted == true).length ==
            permissions.length;
    if (!isGranted) {
      // content = 'Heyya needs access to your photos. So you can include them in your profile.';
      GetBottomAlert.showPermissionAlert(
          doneCallback: () {
            openAppSettings();
          },
          content: tipContent);
    }
    return isGranted;
  }

  static signOutUser() async {
    final account = Session.getAccount();
    await ImManager.shared.signOut();
    if (account?.type == LogInType.GOOGLE.toShortString()) {
      await googleSignInInstance.signOut();
    }
    clearData();
    resignToSignin();
  }

  static resignToSignin() {
    Get.offAllNamed(Routes.SIGN);
  }

  static clearData() {
    final HeyStorage _storage = Get.find<HeyStorage>();
    _storage.saveToken('');
    _storage.saveSig('');
    Session.shard().user = null;
    Session.shard().account = null;
  }

  static updateCurrentUserProfile() async {
    UserEntity user = await UserRepository().getUserProfile();
    Session.saveUser(user);
  }

  static updateRelationNum() async {
    var relation = await RelationRepository().getRelationNum();
    Session.shard().updateRelation(relation);
  }

  static switchToTabbarPage() {
    Get.offAllNamed(Routes.TABBAR);
  }
}

extension LaunchManager on AppManager {
  static bool isUserExist() {
    return Get.find<HeyStorage>().getToken().isNotEmpty &&
        Get.find<HeyStorage>().getSig().isNotEmpty &&
        Get.find<HeyStorage>().getUser() != null;
  }

  static bool didUploadVerifiedVideo() {
    var medias = Session.getUser()?.medias;
    bool hasVideo = false;
    if (medias != null) {
      for (MediaEntity m in medias) {
        if (m.type == MediaType.VERIFY_VIDEO ||
            m.type == MediaType.MAIN_VIDEO) {
          hasVideo = true;
          break;
        }
      }
    }
    //for test
    //hasVideo = false;
    return hasVideo;
  }

  static routerMap() {
    if (LaunchManager.isUserExist()) {
      AppManager.initialLogin();
      AppManager.switchToTabbarPage();
    } else {
      FlutterNativeSplash.remove();
      Get.offAllNamed(Routes.GUIDING);
    }
  }
}
