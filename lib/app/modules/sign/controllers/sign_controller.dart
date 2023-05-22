import 'dart:io';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:heyya/app/core/utils/app_manager.dart';
import 'package:heyya/app/core/utils/get_bottom_sheet.dart';
import 'package:heyya/app/core/utils/get_snackbar.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/network/exceptions/base_exception.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:video_player/video_player.dart';
import '../../../core/enum/device.dart';
import '../../../data/local/Storage/storage.dart';
import '../../../data/repository/account_repository.dart';
import '../../../flavors/build_config.dart';
import '../../../routes/app_pages.dart';

class SignController extends GetxController {
  final HeyStorage _storage = Get.find<HeyStorage>();
  final logger = BuildConfig.instance.config.logger;
  late VideoPlayerController player;
  Rx<bool> playerInitialized = false.obs;

  final _repository = AccountRepository();

  GoogleSignInAccount? currentUser;

  bool isSignIn = false;

  void appleSignIn() async {
    String isShow = HeyStorage().getString('google_sign');
    if (isShow.isEmpty && Platform.isIOS) {
      GetBottomSheetAction.showPPSAPopUps(Get.context!, 'google_sign');
      return;
    }
    final cancelLoading = showLoading();
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
        ],
      );
      String? idToken = credential.identityToken;
      if (idToken != null) {
        _pushSignIn(idToken, LogInType.APPLEID);
      }
      cancelLoading();
    } on Exception catch (e) {
      print('google error: ${e.toString()}');
      cancelLoading();
    }
  }

  googleSignIn() async {
    String isShow = HeyStorage().getString('google_sign');
    if (isShow.isEmpty && Platform.isAndroid) {
      GetBottomSheetAction.showPPSAPopUps(Get.context!, 'google_sign');
      return;
    }

    if (currentUser != null) {
      fetchToken();
      return;
    }
    final cancelLoading = showLoading();
    try {
      await googleSignInInstance.signIn();
      cancelLoading();
    } catch (error) {
      print(error);
      cancelLoading();
      // HeySnackBar.showError(error.toString());
      //Google登录失败时，进行设备号登录
      deviceSignIn();
    }
  }

  deviceSignIn() async {
    // Get.toNamed(Routes.EDIT_VIDEO_AVATAR,
    //     arguments:
    //         "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.daimg.com%2Fuploads%2Fallimg%2F210114%2F1-210114151951.jpg&refer=http%3A%2F%2Fimg.daimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1670215936&t=b685071122b1383a268510600d5d6168");
    // return;
    String isShow = HeyStorage().getString('device_sign');
    if (isShow.isEmpty && Platform.isAndroid) {
      GetBottomSheetAction.showPPSAPopUps(Get.context!, 'device_sign');
      return;
    }

    final cancelLoading = showLoading();
    var account = await HeyStorage().getUuid();
    _pushSignIn(account, LogInType.DEVICE);
    cancelLoading();
  }

  void _pushSignIn(String account, LogInType type) async {
    final cancelLoading = showLoading();
    try {
      var heyAccount = await _repository.signIn(account, type);
      cancelLoading();
      logger.i(heyAccount.toJson());
      await _storage.saveToken(heyAccount.token);
      await _storage.saveSig(heyAccount.sig);
      Session.updateUser(heyAccount.user);
      Session.updateAccount(heyAccount);
      routerMap();
    } on BaseException catch (e) {
      cancelLoading();
      GetSnackbarTool.showText(text: e.message, type: GetSnackbarType.failure);
    }
  }

  routerMap() {
    // var medias = Session.getUser()?.medias;
    // bool hasVideo = false;

    // if (medias != null) {
    //   for (MediaEntity m in medias) {
    //     if (m.type == MediaType.MAIN_VIDEO) {
    //       hasVideo = true;
    //       break;
    //     }
    //   }
    // }

    // //测试
    // //hasVideo = true;
    // if (hasVideo) {
    //   AppManager.initialLogin();
    //   AppManager.switchToTabbarPage();
    // } else {
    //   FlutterNativeSplash.remove();
    //   Get.offAllNamed(Routes.GUIDING);
    // }

    //性别必填:是否需要完善性别
    if (UserProfile.complete(infomation: Infomation.gender, needed: false)) {
      FlutterNativeSplash.remove();
      Get.offAllNamed(Routes.GUIDING);
    } else if (!UserProfile.completeProfileIfNeeded(
        needed: true, showAlert: false)) {
      //待完善信息
      AppManager.initialLogin();
      AppManager.switchToTabbarPage();
    }
  }

  fetchToken() {
    currentUser?.authentication.then((value) {
      String? token = value.idToken;
      if (token != null) {
        _pushSignIn(token, LogInType.GOOGLE);
      }
    });
  }

  @override
  void onInit() {
    super.onInit();

    var token = _storage.getToken();
    var imSig = _storage.getSig();
    var user = _storage.getUser();

    if (token.isNotEmpty && imSig.isNotEmpty) {
      isSignIn = true;
    }

    if (!isSignIn) {
      googleSignInInstance.onCurrentUserChanged
          .listen((GoogleSignInAccount? account) {
        currentUser = account;
        if (currentUser != null) {
          fetchToken();
        }
      });
      // googleSignInInstance.signInSilently();
    }
  }

  @override
  void onReady() {
    super.onReady();
    player = VideoPlayerController.asset('assets/video/sign.mp4');
    player.setLooping(true);
    player.initialize().then((_) {
      playerInitialized.value = true;
      player.play();
    });

    if (isSignIn) {
      routerMap();
      FlutterNativeSplash.remove();
    } else {
      FlutterNativeSplash.remove();
    }
  }

  @override
  void onClose() {
    super.onClose();
    FlutterNativeSplash.remove();
  }

  String signInwithPlatform() {
    if (GetPlatform.isIOS) {
      return "Sign in with Apple";
    } else if (GetPlatform.isAndroid) {
      return "Sign in with Google";
    } else {
      return "Sign in with Device";
    }
  }

  String signInwithDevice() {
    if (GetPlatform.isIOS) {
      return "Sign in with iPhone";
    } else if (GetPlatform.isAndroid) {
      return "Sign in with Phone";
    } else {
      return "Sign in with Device";
    }
  }
}
