import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/enum/media_type.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/widget/heyya_assets_picker_builder.dart';
import 'package:heyya/app/data/model/media_entity.dart';
import 'package:heyya/app/data/model/moment_entity.dart';
import 'package:heyya/app/data/repository/media_repository.dart';
import 'package:heyya/app/data/repository/moment_repository.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/network/exceptions/base_exception.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class MomentPostController extends GetxController {
  //TODO: Implement MomentPostController

  RxString content = "".obs;

  final MomentRepository _repository = MomentRepository();

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

  Future<bool> postMoment() async {
    try {
      final assetsController = Get.find<HeyyaAssetsPickerController>();
      final fileUrls = await assetsController.uploadAssets();
      final mediaSaveEntities = fileUrls
          .map((u) => MediaSaveEntity(type: MediaType.PICTURE, url: u))
          .toList();
      final data = MomentSaveEntity(
        userId: int.parse(Session.getUser()?.id ?? "0"),
        medias: mediaSaveEntities,
        content: content.value,
      );
      await _repository.saveMoment(data);
      return true;
    } catch (e) {
      var msg = e is BaseException ? e.message : e.toString();
      HeySnackBar.showError(msg);
      return false;
    }
  }
}
