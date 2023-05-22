import 'package:heyya/app/core/base/base_repository.dart';
import 'package:heyya/app/core/enum/repository_key.dart';
import 'package:heyya/app/flavors/build_config.dart';
import 'package:heyya/generated/json/user_entity.g.dart';
import '../../core/base/response_entity.dart';
import '../../network/dio_provider.dart';
import '../model/user_entity.dart';

class UserRepository extends BaseRepository {
  final _client = DioProvider.tokenClient;

  // String editableKeyToString({required EditableKey key}) {
  //   switch (key) {
  //     case EditableKey.aboutMe:
  //       return "aboutMe";
  //     case EditableKey.nickname:
  //       return "nickname";
  //     case EditableKey.avatar:
  //       return "avatar";
  //     case EditableKey.sex:
  //       return "sex";
  //     case EditableKey.phone:
  //       return "phone";
  //     case EditableKey.email:
  //       return "email";
  //     case EditableKey.instagram:
  //       return "instagram";
  //     case EditableKey.snapchat:
  //       return "snapchat";
  //     case EditableKey.tiktok:
  //       return "tiktok";
  //   }
  // }

  Future<UserEntity> editProfileWith(
      {required EditableKey key, required String value}) async {
    final _api = '/v1/user';
    var path = BuildConfig.instance.config.baseUrl + _api;
    var data = {key.toShortString(): value};
    var resp = _client.put(path, data: data);
    ResponseEntity entity = await callApiWithErrorParser(resp);
    return parseResp(entity);
  }

  Future<UserEntity> editProfile({required Map<String, dynamic> data}) async {
    final _api = '/v1/user';
    var path = BuildConfig.instance.config.baseUrl + _api;
    var resp = _client.put(path, data: data);
    ResponseEntity entity = await callApiWithErrorParser(resp);
    return parseResp(entity);
  }

  Future<UserEntity> getUserProfile({String? id}) async {
    final _api = '/v1/user';
    var path = '';
    if (id == null) {
      path = BuildConfig.instance.config.baseUrl + _api;
    } else {
      path = BuildConfig.instance.config.baseUrl + _api + '/' + id;
    }
    var resp = _client.get(path);
    ResponseEntity entity = await callApiWithErrorParser(resp);
    return parseResp(entity);
  }

  UserEntity parseResp(ResponseEntity resp) {
    return $UserEntityFromJson(resp.data);
  }
}
