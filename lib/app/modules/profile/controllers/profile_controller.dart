import 'package:get/get.dart';
import 'package:heyya/app/core/base/response_entity.dart';
import 'package:heyya/app/core/enum/media_type.dart';
import 'package:heyya/app/core/utils/app_manager.dart';
import 'package:heyya/app/core/utils/get_bottom_alert.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import 'package:heyya/app/core/widget/heyya_webview.dart';
import 'package:heyya/app/data/model/media_entity.dart';
import 'package:heyya/app/data/model/relation_num_entity.dart';
import 'package:heyya/app/data/repository/account_repository.dart';
import 'package:heyya/app/data/repository/relation_repository.dart';
import 'package:heyya/app/data/repository/user_repository.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/modules/video/models/video_preview_model.dart';
import 'package:heyya/app/network/exceptions/base_exception.dart';
import 'package:heyya/app/routes/app_pages.dart';

class ProfileController extends GetxController {
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

  void onResumed() {
    print("onResumed");
  }

  void onPaused() {
    print("onPaused");
  }

  void onInactive() {
    print("onInactive");
  }

  void onDetached() {
    print("onDetached");
  }

  getRelation() async {
    final RelationRepository relationRepository = RelationRepository();
    var relation = await relationRepository.getRelationNum();
    Session.shard().updateRelation(relation);
  }

  toContactInfo() {
    Get.toNamed(Routes.CONTACT_INFO);
  }

  toEditProfile() {
    // if (UserProfile.completeProfileIfNeeded(needed: true)) {
    //   return;
    // }
    Get.toNamed(Routes.EDIT_PROFILE);
  }

  toPP() {
    Get.toNamed(Routes.PP_SA, arguments: HeyyaWebviewType.pp);
  }

  toSA() {
    Get.toNamed(Routes.PP_SA, arguments: HeyyaWebviewType.sa);
  }

  showSignOutAlert() {
    GetBottomAlert.showLogoutAlert(doneCallback: () {
      Get.back();
    }, cancelCallback: () {
      Get.back();
      AppManager.signOutUser();
    });
  }

  showDeleteAccountAlert() {
    GetBottomAlert.showDeleteAccountAlert(doneCallback: () {
      Get.back();
    }, cancelCallback: () {
      Get.back();
      deleteAccount();
    });
  }

  videoVerified() {
    Get.toNamed(Routes.VERIFIED_VIDEOS);
  }

  deleteAccount() async {
    final cancelLoading = showLoading();
    bool success = await deleteAccountRequest();
    cancelLoading();
    if (success) {
      HeySnackBar.showSuccess("Success");
      AppManager.signOutUser();
    }
  }

  Future<bool> deleteAccountRequest() async {
    try {
      await AccountRepository().deleteAccount();
      return true;
    } catch (e) {
      HeySnackBar.showError(e is BaseException ? e.message : e.toString());
      return false;
    }
  }
}
