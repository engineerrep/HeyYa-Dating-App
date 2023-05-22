import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/utils/im_manager.dart';
import 'package:heyya/app/core/widget/heyya_loading_indicator.dart';
import 'package:heyya/app/data/model/user_entity.dart';
import 'package:heyya/app/data/repository/spark_repository.dart';
import 'package:heyya/app/data/repository/user_repository.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/modules/report/models/report_block_state.dart';
import 'package:heyya/app/network/exceptions/base_exception.dart';

class UserProfileController extends GetxController {
  Rx<UserEntity>? user;

  final SparkRepository _repository = SparkRepository();

  Future<void> like(String toUserId) async {
    if (user?.value.liked ?? false) {
      HeySnackBar.showWarning("You already liked this user!");
      return;
    }
    var cancelLoading = showLoading();
    Get.find<ReportBlockState>().willCreateRelationWithUserId = user?.value.id;
    try {
      await _repository.like(int.parse(toUserId));
      cancelLoading();
      final relation = Session.getRelation();
      if (relation != null) {
        relation.myLikeNum += 1;
        Session.shard().updateRelation(relation);
      }
      Get.find<ReportBlockState>().didFinishCreateRelation();
      user?.value.liked = true;
      update();
    } catch (e) {
      cancelLoading();
      HeySnackBar.showError(e is BaseException ? e.message : e.toString());
    }
  }

  //其他地方进入到详情页怎么展示？
  //like/unlike后的用户只能发消息，无其他操作
  //unlike 后不能再次unlike
  Future<void> unlike(String toUserId) async {
    var cancelLoading = showLoading();
    Get.find<ReportBlockState>().willCreateRelationWithUserId = user?.value.id;
    try {
      await _repository.unlike(int.parse(toUserId));
      cancelLoading();
      Get.find<ReportBlockState>().didFinishCreateRelation();
      Get.back();
    } catch (e) {
      cancelLoading();
      HeySnackBar.showError(e is BaseException ? e.message : e.toString());
    }
  }

  onMessage() {
    ImManager.shared.chatWithUser(userId: user?.value.id ?? "", showName: user?.value.nickname ?? "");
  }

  updateUser() async {
    final uid = user?.value.id;
    var cancelLoading = showLoading();
    if (uid != null) {
      final temp = await UserRepository().getUserProfile(id: uid);
      if (user == null) {
        user = Rx(temp);
      } else {
        user?.value = temp;
      }
      update();
    }
    cancelLoading();
  }

  @override
  void onInit() {
    super.onInit();
    final _user = Get.arguments as UserEntity?;
    if (_user != null) {
      user = Rx(_user);
    }
  }

  @override
  void onReady() {
    super.onReady();
    updateUser();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
