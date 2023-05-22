import 'dart:ffi';

import 'package:heyya/app/core/base/base_repository.dart';
import 'package:heyya/app/core/base/response_entity.dart';
import 'package:heyya/app/data/model/moment_entity.dart';
import 'package:heyya/app/data/model/page_info_entity.dart';
import 'package:heyya/app/flavors/build_config.dart';
import 'package:heyya/app/network/dio_provider.dart';

abstract class _MomentApi {
  static String get list => '/v1/moment';
  static String get save => '/v1/moment/save';
  static String get thumbUps => '/v1/thumb-ups';
}

class MomentRepository extends BaseRepository {
  final _client = DioProvider.tokenClient;

  Future<PageInfoEntity<MomentEntity>> getMoments(
      PageInfoRequest pageInfoReq) async {
    var path = BuildConfig.instance.config.baseUrl + _MomentApi.list;

    final resp = _client.get(path, queryParameters: pageInfoReq.toJson());

    ResponseEntity entity = await callApiWithErrorParser(resp);
    return PageInfoEntity.fromJson(entity.data);
  }

  Future<void> saveMoment(MomentSaveEntity data) async {
    final path = BuildConfig.instance.config.baseUrl + _MomentApi.save;
    final resp = _client.post(path, data: data.toJson());
    await callApiWithErrorParser(resp);
  }

  Future<void> thumbUps(int momentId, int toUserId) async {
    final path = BuildConfig.instance.config.baseUrl + _MomentApi.thumbUps;
    final resp =
        _client.post(path, data: {'momentId': momentId, 'toUserId': toUserId});
    await callApiWithErrorParser(resp);
  }

  Future<void> deleteThumbUps(int momentId) async {
    final path = BuildConfig.instance.config.baseUrl +
        _MomentApi.thumbUps +
        '/$momentId';
    final resp = _client.delete(path);
    await callApiWithErrorParser(resp);
  }
}
