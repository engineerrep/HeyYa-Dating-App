import 'package:get/get.dart';
import 'package:heyya/app/core/enum/repository_key.dart';
import 'package:heyya/app/core/utils/app_manager.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/widget/heyya_assets_picker_builder.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import 'package:heyya/app/data/model/user_entity.dart';
import 'package:heyya/app/data/repository/user_repository.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/network/exceptions/base_exception.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class EditVideoAvatarController extends GetxController {
  String? avatarUrl;
  final UserRepository userRepository = UserRepository();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      avatarUrl = Get.arguments as String;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  takePhoto() async {
    final AssetEntity? result = await pickFromCamera(Get.context!);
    if (result == null) {
      return;
    }
    final cancelLoading = showLoading();
    try {
      final avatars = await HeyyaAssetsPickerController.uploadAsset([result]);
      cancelLoading();
      if (avatars.length == 1) {
        avatarUrl = avatars.first;
        update();
      }
    } catch (e) {
      cancelLoading();
    }
  }

  later() {
    AppManager.initialLogin();
    AppManager.switchToTabbarPage();
  }

  confirm() async {
    if (avatarUrl == null) {
      return;
    }
    final cancelLoading = showLoading();
    try {
      Map<String, dynamic> data = Map<String, dynamic>();
      if (avatarUrl!.length > 0) {
        data[EditableKey.avatar.toShortString()] = avatarUrl!;
      }
      UserEntity user = await userRepository.editProfile(data: data);
      cancelLoading();
      Session.updateUser(user);
      later();
    } catch (e) {
      cancelLoading();
      var msg = e is BaseException ? e.message : e.toString();
      HeySnackBar.showError(msg);
      return false;
    }
  }
}
