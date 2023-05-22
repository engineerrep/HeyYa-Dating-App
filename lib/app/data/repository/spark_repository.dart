import 'package:heyya/app/core/base/base_repository.dart';
import 'package:heyya/app/core/base/response_entity.dart';
import 'package:heyya/app/data/model/page_info_entity.dart';
import 'package:heyya/app/data/model/spark_entity.dart';
import 'package:heyya/app/flavors/build_config.dart';
import 'package:heyya/app/network/dio_provider.dart';

abstract class _SparkApi {
  static String get spark => '/v1';
  static String get like => '/v1/friend/save';
  static String get unlike => '/v1/unlike';
}

class SparkRepository extends BaseRepository {
  final _client = DioProvider.tokenClient;

  Future<PageInfoEntity<SparkEntity>> getSparks(
      PageInfoRequest pageInfoReq) async {
    var path = BuildConfig.instance.config.baseUrl + _SparkApi.spark;
    final resp = _client.get(path, queryParameters: pageInfoReq.toJson());
    ResponseEntity entity = await callApiWithErrorParser(resp);
    return PageInfoEntity.fromJson(entity.data);
  }

  Future<void> like(int toUserId) async {
    final path = BuildConfig.instance.config.baseUrl + _SparkApi.like;
    final resp = _client.post(path, data: {'toUserId': toUserId});
    try {
      await callApiWithErrorParser(resp);
    } catch (_) {}
  }

  Future<void> unlike(int toUserId) async {
    final path = BuildConfig.instance.config.baseUrl + _SparkApi.unlike;
    final resp = _client.post(path, data: {'toUserId': toUserId});
    try {
      await callApiWithErrorParser(resp);
    } catch (_) {}
  }
}
