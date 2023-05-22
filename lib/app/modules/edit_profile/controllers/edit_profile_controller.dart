import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/enum/repository_key.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/widget/heyya_assets_picker_builder.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import 'package:heyya/app/data/model/user_entity.dart';
import 'package:heyya/app/data/repository/user_repository.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/modules/verified_videos/controllers/verified_videos_controller.dart';
import 'package:heyya/app/network/exceptions/base_exception.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class EditProfileController extends GetxController {
  final UserRepository userRepository = UserRepository();
  final assetsController = HeyyaAssetsPickerController();

  var avatar = "".obs;
  var userName = "".obs;
  var sex = "".obs;
  var aboutMe = "".obs;

  final nameController = TextEditingController();
  final aboutController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final videoContoller = VerifiedVideosController();
    videoContoller.isFromProfile = true;
    Get.put<VerifiedVideosController>(videoContoller);
  }

  @override
  void onReady() {
    super.onReady();

    sex.value = Session.shard().user?.value.sex ?? "";
    userName.value = Session.shard().user?.value.nickname ?? "";
    aboutMe.value = Session.shard().user?.value.aboutMe ?? "";

    if (userName.value.length > 0) {
      nameController.text = userName.value;
    }
    if (aboutMe.value.length > 0) {
      aboutController.text = aboutMe.value;
    }
  }

  choosePhoto() async {
    try {
      await assetsController.pickAssetsWith(context: Get.context!, maxCount: 1);
      if (assetsController.photos.length == 1) {
        final cancelLoading = showLoading();
        try {
          final avatars = await assetsController.uploadAssets();
          avatar.value = avatars.first;
          update();
          cancelLoading();
        } catch (e) {
          cancelLoading();
        }
      }
    } catch (_) {}
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
        avatar.value = avatars.first;
        update();
      }
    } catch (e) {
      cancelLoading();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<bool> editProfile() async {
    try {
      Map<String, dynamic> data = Map<String, dynamic>();
      if (userName.value.length > 0) {
        data[EditableKey.nickname.toShortString()] = userName.value;
      }
      if (aboutMe.value.length > 0) {
        data[EditableKey.aboutMe.toShortString()] = aboutMe.value;
      }
      if (sex.value.length > 0) {
        data[EditableKey.sex.toShortString()] = sex.value;
      }
      if (avatar.value.length > 0) {
        data[EditableKey.avatar.toShortString()] = avatar.value;
      }
      UserEntity user = await userRepository.editProfile(data: data);
      Session.updateUser(user);
      return true;
    } catch (e) {
      var msg = e is BaseException ? e.message : e.toString();
      HeySnackBar.showError(msg);
      return false;
    }
  }

  Future<bool> editAboutMe() async {
    try {
      UserEntity user = await userRepository.editProfileWith(
          key: EditableKey.aboutMe, value: aboutMe.value);
      Session.updateUser(user);
      update();
      return true;
    } catch (e) {
      var msg = e is BaseException ? e.message : e.toString();
      HeySnackBar.showError(msg);
      return false;
    }
  }

  Future<bool> editName() async {
    try {
      UserEntity user = await userRepository.editProfileWith(
          key: EditableKey.nickname, value: userName.value);
      Session.updateUser(user);
      update();
      return true;
    } catch (e) {
      var msg = e is BaseException ? e.message : e.toString();
      HeySnackBar.showError(msg);
      return false;
    }
  }

  Future<bool> editGender() async {
    if (sex.value.length == 0) {
      return false;
    }
    try {
      UserEntity user = await userRepository.editProfileWith(
          key: EditableKey.sex, value: sex.value);
      Session.updateUser(user);
      update();
      return true;
    } catch (e) {
      var msg = e is BaseException ? e.message : e.toString();
      HeySnackBar.showError(msg);
      return false;
    }
  }

  Future<bool> editAvatar({required String avatar}) async {
    try {
      UserEntity user = await userRepository.editProfileWith(
          key: EditableKey.avatar, value: avatar);
      Session.updateUser(user);
      update();
      return true;
    } catch (e) {
      var msg = e is BaseException ? e.message : e.toString();
      HeySnackBar.showError(msg);
      return false;
    }
  }
}
