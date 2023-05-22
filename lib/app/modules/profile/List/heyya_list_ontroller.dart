import 'package:get/get.dart';
import 'package:heyya/app/data/model/page_info_entity.dart';
import 'package:heyya/app/data/model/relation_user_entity.dart';
import 'package:heyya/app/data/repository/heyya_list_repostitory.dart';
import 'package:heyya/app/flavors/build_config.dart';
import 'package:heyya/app/modules/profile/list/heyya_list_provider.dart';

class HeyyaListController extends GetxController
    with StateMixin<PageInfoEntity<RelationUserEntity>> {
  final logger = BuildConfig.instance.config.logger;

  List<RelationUserEntity> _users = <RelationUserEntity>[];
  bool _hasNextpage = true;
  int number = 1;

  int pageCount() {
    return _users.length;
  }

  bool hasNextpage() {
    return _hasNextpage;
  }

  RelationUserEntity object(int index) {
    return _users[index];
  }

  void removeUser({required String userId}) {
    _users.removeWhere((relation) => relation.toUser.id == userId);
    if (_users.length > 0) {
      change(null, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.empty());
    }
  }

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

  Future<void> getUserPageInfos(
      {required ApiType type, required bool isRefresh}) async {
    number = isRefresh ? 1 : number + 1;
    final pageInfoReq = PageInfoRequest(number: number, size: 10);
    logger.i(pageInfoReq.toJson());
    await Future.delayed(const Duration(milliseconds: 500));

    HeyyaListProvider.getUserPageInfos(type: type, pageInfoReq: pageInfoReq)
        .then((pageinfo) {
      if (pageinfo.pageNum == 1) {
        _users.clear();
      }
      _users.addAll(pageinfo.list);
      _hasNextpage = pageinfo.hasNextPage;
      if (_users.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(null, status: RxStatus.success());
      }
    }, onError: (error) {
      change(null, status: RxStatus.error(error.toString()));
    });
  }
}
