import 'package:get/get.dart';
import 'package:heyya/app/core/utils/hey_snack_bar.dart';
import 'package:heyya/app/core/utils/im_manager.dart';
import 'package:heyya/app/data/model/moment_entity.dart';
import 'package:heyya/app/data/model/page_info_entity.dart';
import 'package:heyya/app/data/repository/moment_repository.dart';
import 'package:heyya/app/flavors/build_config.dart';
import 'package:heyya/app/modules/report/models/report_block_state.dart';
import 'package:heyya/app/network/exceptions/base_exception.dart';

class MomentController extends GetxController
    with StateMixin<List<MomentEntity>> {
  final logger = BuildConfig.instance.config.logger;

  final MomentRepository _repository = MomentRepository();

  // final RxList<MomentEntity> moments = RxList<MomentEntity>();
  final List<MomentEntity> moments = [];
  bool hasMore = false;
  bool get isEmpty => moments.isEmpty;

  int _number = 1;
  late Worker _blockWoker;
  late Worker _deleteWoker;

  _notifyChanges() {
    change(moments, status: isEmpty ? RxStatus.empty() : RxStatus.success());
  }

  _onListenBlockUser(String blockedUserId) {
    moments.removeWhere((m) => m.userId == blockedUserId);
    _notifyChanges();
  }

  _onListenDeleteMoment(String momentId) {
    moments.removeWhere((m) => m.id == momentId);
    _notifyChanges();
  }

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.loading());
    loadNext(true);
  }

  @override
  void onReady() {
    super.onReady();

    //监听是否Block用户
    _blockWoker =
        ever(Get.find<ReportBlockState>().didBlockUserId, _onListenBlockUser);
    _deleteWoker = ever(
        Get.find<ReportBlockState>().didDeleteMomentId, _onListenDeleteMoment);
  }

  @override
  void onClose() {
    _blockWoker.dispose();
    _deleteWoker.dispose();
    super.onClose();
  }

  Future<void> loadNext(bool isRefresh) async {
    final number = isRefresh ? 1 : _number + 1;
    final data = PageInfoRequest(number: number);
    logger.i(data.toJson());
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final pageInfo = await _repository.getMoments(data);
      if (isRefresh) moments.clear();
      moments.addAll(pageInfo.list);
      hasMore = pageInfo.hasNextPage;
      _number = number;
    } catch (e) {
      HeySnackBar.showError(e is BaseException ? e.message : e.toString());
    } finally {
      _notifyChanges();
    }
  }

  Future<void> thumbUp(String momentId, String toUserId) async {
    try {
      await _repository.thumbUps(int.parse(momentId), int.parse(toUserId));
      final index = moments.indexWhere((m) => m.id == momentId);
      if (index < 0) {
        return;
      }
      final thumbUppedMoment = moments[index];
      if (thumbUppedMoment.isThumb) {
        return;
      }
      moments[index] = thumbUppedMoment.copyWith(
        isThumb: true,
        thumbCount: thumbUppedMoment.thumbCount + 1,
      );
      change(moments, status: RxStatus.success());
    } catch (e) {
      HeySnackBar.showError(e is BaseException ? e.message : e.toString());
    }
  }

  Future<void> deleteThumbUp(String momentId) async {
    try {
      await _repository.deleteThumbUps(int.parse(momentId));
      final index = moments.indexWhere((m) => m.id == momentId);
      if (index < 0) {
        return;
      }
      final thumbUppedMoment = moments[index];
      if (thumbUppedMoment.isThumb == false) {
        return;
      }
      moments[index] = thumbUppedMoment.copyWith(
        isThumb: false,
        thumbCount: thumbUppedMoment.thumbCount - 1,
      );
      change(moments, status: RxStatus.success());
    } catch (e) {
      HeySnackBar.showError(e is BaseException ? e.message : e.toString());
    }
  }

  void messageUser(MomentEntity entity) {
    ImManager.shared
        .chatWithUser(userId: entity.userId, showName: entity.user.nickname);
  }
}
