import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/enum/repository_key.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/data/model/user_entity.dart';
import 'package:heyya/app/data/repository/user_repository.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/network/exceptions/base_exception.dart';

class ContactInfoController extends GetxController {
  final UserRepository userRepository = UserRepository();
  late TextEditingController phoneEditingController;
  late TextEditingController emailEditingController;
  late TextEditingController instagramEditingController;
  late TextEditingController snapchatEditingController;
  late TextEditingController tiktokEditingController;

  bool canSave() {
    return phoneEditingController.text.length > 0 ||
        emailEditingController.text.length > 0 ||
        instagramEditingController.text.length > 0 ||
        snapchatEditingController.text.length > 0 ||
        tiktokEditingController.text.length > 0;
  }

  Future<bool> saveAction() async {
    try {
      Map<String, dynamic> data = Map<String, dynamic>();
      if (phoneEditingController.text.length > 0) {
        data[EditableKey.phone.toShortString()] = phoneEditingController.text;
      }
      if (emailEditingController.text.length > 0) {
        data[EditableKey.email.toShortString()] = emailEditingController.text;
      }
      if (instagramEditingController.text.length > 0) {
        data[EditableKey.instagram.toShortString()] = instagramEditingController.text;
      }
      if (snapchatEditingController.text.length > 0) {
        data[EditableKey.snapchat.toShortString()] = snapchatEditingController.text;
      }
      if (tiktokEditingController.text.length > 0) {
        data[EditableKey.tiktok.toShortString()] = tiktokEditingController.text;
      }
      UserEntity user = await userRepository.editProfile(data: data);
      Session.updateUser(user);
      HeySnackBar.showSuccess("Success");
      return true;
    } catch (e) {
      var msg = e is BaseException ? e.message : e.toString();
      HeySnackBar.showError(msg);
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();

    phoneEditingController = TextEditingController()
      ..addListener(() {
        canSave();
        update();
      });

    emailEditingController = TextEditingController()
      ..addListener(() {
        canSave();
        update();
      });

    instagramEditingController = TextEditingController()
      ..addListener(() {
        canSave();
        update();
      });

    snapchatEditingController = TextEditingController()
      ..addListener(() {
        canSave();
        update();
      });

    tiktokEditingController = TextEditingController()
      ..addListener(() {
        canSave();
        update();
      });
  }

  @override
  void onReady() {
    super.onReady();

    final user = Session.getUser();
    final phone = user?.phone;
    final email = user?.email;
    final tiktok = user?.tiktok;
    final snapchat = user?.snapchat;
    final instagram = user?.instagram;
    if (phone != null && phone.isNotEmpty) {
      phoneEditingController.text = phone;
    }
    if (email != null && email.isNotEmpty) {
      emailEditingController.text = email;
    }
    if (tiktok != null && tiktok.isNotEmpty) {
      tiktokEditingController.text = tiktok;
    }
    if (snapchat != null && snapchat.isNotEmpty) {
      snapchatEditingController.text = snapchat;
    }
    if (instagram != null && instagram.isNotEmpty) {
      instagramEditingController.text = instagram;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
