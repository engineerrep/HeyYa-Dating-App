// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:dio/dio.dart';
import 'package:heyya/app/core/base/response_entity.dart';
import 'package:heyya/app/core/enum/media_type.dart';
import 'package:heyya/app/data/model/media_entity.dart';
import 'package:heyya/app/data/session/session.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import '../../../generated/json/media_entity.g.dart';
import '../../core/base/base_repository.dart';
import '../../core/base/response_list_entity.dart';
import '../../flavors/build_config.dart';
import '../../network/dio_provider.dart';

class MediaRepository extends BaseRepository {
  // custom class defining all the API details

  // client for making calls to the API
  final _client = DioProvider.tokenClient;

  Future<List<String>> uploadMedias(List<XFile> files, MediaType type) async {
    var path = BuildConfig.instance.config.baseUrl + '/v1/batch-upload';

    List<MultipartFile> mulFils = [];
    for (var file in files) {
      var f = await MultipartFile.fromFile(
        file.path,
        filename: file.path.split("/").last, //不能重复
      );
      mulFils.add(f);
    }

    FormData d = FormData.fromMap({
      "files": mulFils,
    });
    var resp = _client.post(path, data: d);

    try {
      ResponseListEntity entity = await callListApiWithErrorParser(resp);
      var urls = entity.data.map((e) => e.toString()).toList();
      return urls;
    } on Exception catch (ex) {
      throw ex;
    }
  }

  Future<ResponseEntity> setMainMedia(String mediaId) async {
    var path = BuildConfig.instance.config.baseUrl + '/v1/media/${mediaId}';
    var resp = _client.put(path);
    ResponseEntity entity = await callApiWithErrorParser(resp);
    return entity;
  }

  Future<ResponseEntity> deleteMedia(String mediaId) async {
    var path = BuildConfig.instance.config.baseUrl + '/v1/media/${mediaId}';
    var resp = _client.delete(path);
    ResponseEntity entity = await callApiWithErrorParser(resp);
    return entity;
  }

  Future<MediaEntity?> saveMedia(String url, MediaType type,
      {required String content, String? mediaId, String? cover}) async {
    String? id = Session.getUser()?.id;
    if (id == null) {
      return null;
    }
    if (mediaId == null) {
      var path = BuildConfig.instance.config.baseUrl + '/v1/media/save';
      var data = {'resourceId': id, 'url': url, 'type': type.toShortString()};
      if (content.isNotEmpty) {
        data['content'] = content;
      }
      if (cover != null) {
        data['cover'] = cover;
      }
      var resp = _client.post(path, data: data);
      ResponseEntity entity = await callApiWithErrorParser(resp);
      final media = $MediaEntityFromJson(entity.data);
      return media;
    } else {
      var path = BuildConfig.instance.config.baseUrl + '/v1/media';
      var data = {'id': mediaId, 'url': url, 'type': type.toShortString()};
      if (content.isNotEmpty) {
        data['content'] = content;
      }
      if (cover != null) {
        data['cover'] = cover;
      }
      var resp = _client.put(path, data: data);
      ResponseEntity entity = await callApiWithErrorParser(resp);
      final media = $MediaEntityFromJson(entity.data);
      return media;
    }
  }
}

extension SaveVideohelper on MediaRepository {
  void _saveVideo(MediaEntity entity) {
    var contains = false;
    final user = Session.getUser();
    final medias = user?.medias;
    if (medias != null) {
      for (var media in medias) {
        if (media.id == entity.id) {
          contains = true;
          break;
        }
      }
      if (contains) {
        medias.removeWhere((element) => element.id == entity.id);
      }
      medias.insert(0, entity);
      user?.medias = medias;
      if (user != null) {
        Session.updateUser(user);
      }
    }
  }
}
