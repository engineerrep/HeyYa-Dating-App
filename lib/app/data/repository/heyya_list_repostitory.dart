import 'package:heyya/app/core/base/base_repository.dart';
import 'package:heyya/app/core/base/response_entity.dart';
import 'package:heyya/app/data/model/page_info_entity.dart';
import 'package:heyya/app/data/model/relation_user_entity.dart';
import 'package:heyya/app/data/model/short_video_entity.dart';
import 'package:heyya/app/flavors/build_config.dart';
import 'package:heyya/app/network/dio_provider.dart';

//all get
enum ApiType {
  mylikeList,
  likemeList,
  matchList,
  visitorList,
  blockList,
  videoList,
}

class HeyyaListRepository extends BaseRepository {
  final _client = DioProvider.tokenClient;

  Future<PageInfoEntity<ShortVideoEntity>> getVideoListPageInfos(
      {required PageInfoRequest pageInfoReq}) async {
    var path =
        BuildConfig.instance.config.baseUrl + apiForType(ApiType.videoList);
    var resp = _client.get(path, queryParameters: {
      "number": pageInfoReq.number,
      "size": pageInfoReq.size
    });
    ResponseEntity entity = await callApiWithErrorParser(resp);
    return PageInfoEntity.fromJson(entity.data);
  }

  Future<PageInfoEntity<RelationUserEntity>> getUserPageInfos(
      {required ApiType type, required PageInfoRequest pageInfoReq}) async {
    var path = BuildConfig.instance.config.baseUrl + apiForType(type);
    var resp = _client.get(path, queryParameters: {
      "number": pageInfoReq.number,
      "size": pageInfoReq.size
    });
    ResponseEntity entity = await callApiWithErrorParser(resp);
    return PageInfoEntity.fromJson(entity.data);
  }

  String apiForType(ApiType type) {
    switch (type) {
      case ApiType.likemeList:
        return "/v1/friend/like-me";
      case ApiType.mylikeList:
        return "/v1/friend/me-like";
      case ApiType.matchList:
        return "/v1/friend/match";
      case ApiType.blockList:
        return "/v1/block";
      case ApiType.visitorList: //待完善
        return "/v1/visitor/search";
      case ApiType.videoList:
        return "/v1/video/search";
    }
  }
}
