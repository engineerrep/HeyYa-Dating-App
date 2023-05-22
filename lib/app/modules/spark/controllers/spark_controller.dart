import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/utils/file_cache.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/utils/im_manager.dart';
import 'package:heyya/app/data/model/page_info_entity.dart';
import 'package:heyya/app/data/model/spark_entity.dart';
import 'package:heyya/app/data/repository/report_block_repository.dart';
import 'package:heyya/app/data/repository/spark_repository.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:heyya/app/flavors/build_config.dart';
import 'package:heyya/app/modules/report/models/report_block_state.dart';
import 'package:heyya/app/network/exceptions/base_exception.dart';
import 'package:swipable_stack/swipable_stack.dart';

class SparkController extends FullLifeCycleController
    with StateMixin<List<SparkEntity>> {
  final SwipableStackController swipableStackController =
      SwipableStackController();

  List<SparkEntity> get sparks => _sparks;
  final List<SparkEntity> _sparks = [];

  final SparkRepository _repository = SparkRepository();
  final logger = BuildConfig.instance.config.logger;

  int _number = 0;
  bool _loading = false;
  late Worker _blockWorker;
  late Worker _createRelaotinWorker;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      default:
        break;
    }
  }

  _onListenBlockUser(String blockedUserId) {
    List<SparkEntity> sparksToRemove = [];
    for (int i = swipableStackController.currentIndex; i < sparks.length; i++) {
      if (sparks[i].id == blockedUserId) {
        sparksToRemove.add(sparks[i]);
        break;
      }
    }
    _sparks.removeWhere((s) => sparksToRemove.contains(s));
    final left = _sparks.length - sparksToRemove.length;
    // 需要加载更多
    if (swipableStackController.currentIndex >= left - 5) {
      // 显示 loading 状态
      if (swipableStackController.currentIndex >= left - 1) {
        change([], status: RxStatus.loading());
      } else {
        change(sparks,
            status: sparks.isEmpty ? RxStatus.empty() : RxStatus.success());
      }
      loadNext(false);
    } else {
      change(sparks,
          status: sparks.isEmpty ? RxStatus.empty() : RxStatus.success());
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    change([], status: RxStatus.loading());
    loadNext(true);

    //监听是否Block用户
    _blockWorker =
        ever(Get.find<ReportBlockState>().didBlockUserId, _onListenBlockUser);
    //监听用户详情like/pass用户
    _createRelaotinWorker = ever(
        Get.find<ReportBlockState>().didCreateRelationWithUserId,
        _onListenBlockUser);
  }

  @override
  void onClose() {
    _blockWorker.dispose();
    _createRelaotinWorker.dispose();
    super.onClose();
  }

  SparkEntity get currentStackEntity {
    final index = swipableStackController.currentIndex;
    return sparks[index];
  }

  emitEmpty() {
    change([], status: RxStatus.empty());
  }

  Future<void> loadNext(bool isRefresh) async {
    if (_loading) {
      return;
    }
    _loading = true;
    await Future.delayed(const Duration(milliseconds: 500));
    final number = isRefresh ? 1 : _number + 1;
    try {
      final data = PageInfoRequest(number: number, size: 10);
      logger.i(data.toJson());
      final pageInfo = await _repository.getSparks(data);
      if (isRefresh) _sparks.clear();
      //pageInfo.list.removeWhere((spark) => !spark.hasMedia);
      _sparks.addAll(pageInfo.list);
      if (pageInfo.list.isNotEmpty) {
        for (SparkEntity element in pageInfo.list) {
          for (var media in element.medias) {
            if (media.url.isNotEmpty) {
              EMCache.shared.saveFile(EMFileType.video, url: media.url);
            }
          }
        }
      }
      _number = number;
    } catch (e) {
      HeySnackBar.showError(e is BaseException ? e.message : e.toString());
    } finally {
      change(sparks,
          status: sparks.isEmpty ? RxStatus.empty() : RxStatus.success());
      // isRefresh == true reset swipableStackController.currentIndex
      if (isRefresh) swipableStackController.currentIndex = 0;
      _loading = false;
    }
  }

  messageUser() {
    ImManager.shared.chatWithUser(
        userId: currentStackEntity.id, showName: currentStackEntity.nickname);
  }

  Future<void> like(String toUserId) async {
    try {
      await _repository.like(int.parse(toUserId));
      final relation = Session.getRelation();
      if (relation != null) {
        relation.myLikeNum += 1;
        Session.shard().updateRelation(relation);
      }
    } catch (e) {
      HeySnackBar.showError(e is BaseException ? e.message : e.toString());
    }
  }

  Future<void> unlike(String toUserId) async {
    try {
      await _repository.unlike(int.parse(toUserId));
    } catch (e) {
      HeySnackBar.showError(e is BaseException ? e.message : e.toString());
    }
  }

  Future<void> block(String toUserId) async {
    try {
      final blockRepository = ReportBlockRepository();
      await blockRepository.blockUser(toUserId);
    } catch (e) {
      HeySnackBar.showError(e is BaseException ? e.message : e.toString());
    }
  }
}
