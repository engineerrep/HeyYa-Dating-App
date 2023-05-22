import 'package:get/get.dart';
import 'package:heyya/app/core/base/response_entity.dart';
import 'package:heyya/app/data/model/account_entity.dart';
import 'package:heyya/app/network/dio_provider.dart';
import 'package:heyya/generated/json/account_entity.g.dart';
import '../../core/base/base_repository.dart';
import '../../core/enum/device.dart';
import '../../flavors/build_config.dart';

class AccountRepository extends BaseRepository {
  final _client = DioProvider.tokenClient;

  Future<ResponseEntity> deleteAccount() async {
    final _api = '/v1/del-account';
    var path = BuildConfig.instance.config.baseUrl + _api;
    var resp = _client.delete(path);
    ResponseEntity entity = await callApiWithErrorParser(resp);
    return entity;
  }

  Future<AccountEntity> signIn(String account, LogInType type) async {
    final _api = '/v1/sing-in';
    var data = {
      "account": account,
      "platform": GetPlatform.isIOS ? "IOS" : "ANDROID",
      "type": type.toShortString(),
    };
    if (type == LogInType.APPLEID) {
      data["bundleId"] = "com.heyyateam.heyya";
    }
    var path = BuildConfig.instance.config.baseUrl + _api;
    var resp = _client.post(path, data: data);
    ResponseEntity entity = await callApiWithErrorParser(resp);
    return parseResp(entity);
  }

  AccountEntity parseResp(ResponseEntity entity) {
    return $AccountEntityFromJson(entity.data);
  }
}
