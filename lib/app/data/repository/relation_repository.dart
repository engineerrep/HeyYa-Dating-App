import 'package:heyya/app/core/base/base_repository.dart';
import 'package:heyya/app/core/base/response_entity.dart';
import 'package:heyya/app/data/model/relation_num_entity.dart';
import 'package:heyya/app/flavors/build_config.dart';
import 'package:heyya/app/network/dio_provider.dart';
import 'package:heyya/generated/json/relation_num_entity.g.dart';

class RelationRepository extends BaseRepository {
  final _client = DioProvider.tokenClient;

  Future<RelationNumEntity> getRelationNum() async {
    final _api = '/v1/rel-num';
    final path = BuildConfig.instance.config.baseUrl + _api;
    var resp = _client.get(path);
    ResponseEntity entity = await callApiWithErrorParser(resp);
    return parseResp(entity);
  }

  RelationNumEntity parseResp(ResponseEntity resp) {
    return $RelationNumEntityFromJson(resp.data);
  }
}
