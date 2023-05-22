import 'package:heyya/app/core/base/base_repository.dart';
import 'package:heyya/app/core/base/response_entity.dart';
import 'package:heyya/app/core/enum/feedback_type.dart';
import 'package:heyya/app/flavors/build_config.dart';
import 'package:heyya/app/network/dio_provider.dart';

class ReportBlockRepository extends BaseRepository {
  final _feedbackActionApi = "/v1/feedback"; //post
  final _reportActionApi = "/v1/report"; //post
  final _blockActionApi = "/v1/block"; //post
  final _unblockActionApi = "/v1/block/"; //delete
  final _deleteMomentApi = "/v1/moment/";

  final _client = DioProvider.tokenClient;

  Future<ResponseEntity> feedback(
      {String? content, List<String>? medias}) async {
    var path = BuildConfig.instance.config.baseUrl + _feedbackActionApi;
    Map<String, dynamic> data = {"type": FeedbackType.question.toValue()};
    if (content != null) {
      data["content"] = content;
    }
    if (medias != null) {
      data["medias"] = medias;
    }
    var resp = _client.post(path, data: data);
    ResponseEntity entity = await callApiWithErrorParser(resp);
    return entity;
  }

  Future<ResponseEntity> deleteMoment(String momentId) async {
    var path =
        BuildConfig.instance.config.baseUrl + _deleteMomentApi + momentId;
    var resp = _client.delete(path);
    ResponseEntity entity = await callApiWithErrorParser(resp);
    return entity;
  }

  Future<ResponseEntity> reportUser(
      {required String toUserId,
      required String type,
      String? content,
      List<String>? medias}) async {
    var path = BuildConfig.instance.config.baseUrl + _reportActionApi;
    Map<String, dynamic> data = {"type": type, "toUserId": toUserId};
    if (content != null) {
      data["content"] = content;
    }
    if (medias != null) {
      data["medias"] = medias;
    }
    var resp = _client.post(path, data: data);
    ResponseEntity entity = await callApiWithErrorParser(resp);
    return entity;
  }

  Future<ResponseEntity> blockUser(String uid) async {
    var path = BuildConfig.instance.config.baseUrl + _blockActionApi;
    var data = {"toUserId": uid};
    var resp = _client.post(path, data: data);
    ResponseEntity entity = await callApiWithErrorParser(resp);
    return entity;
  }

  Future<ResponseEntity> unblockUser(String uid) async {
    var path = BuildConfig.instance.config.baseUrl + _unblockActionApi + uid;
    var resp = _client.delete(path);
    ResponseEntity entity = await callApiWithErrorParser(resp);
    return entity;
  }
}
