import 'package:get/get.dart';
import 'package:heyya/app/data/model/page_info_entity.dart';
import 'package:heyya/app/data/model/relation_user_entity.dart';
import 'package:heyya/app/data/repository/heyya_list_repostitory.dart';

class HeyyaListProvider extends GetConnect {
  static final _repository = HeyyaListRepository();
  static Future<PageInfoEntity<RelationUserEntity>> getUserPageInfos(
      {required ApiType type, required PageInfoRequest pageInfoReq}) async {
    return _repository.getUserPageInfos(type: type, pageInfoReq: pageInfoReq);
  }
}
