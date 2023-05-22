import 'package:heyya/app/core/enum/media_state.dart';
import 'package:heyya/generated/json/base/json_convert_content.dart';
import 'package:heyya/app/data/model/media_entity.dart';
import 'package:heyya/app/core/enum/media_type.dart';

MediaEntity $MediaEntityFromJson(Map<String, dynamic> json) {
  final MediaEntity mediaEntity = MediaEntity();
  final String? cover = jsonConvert.convert<String>(json['cover']);
  if (cover != null) {
    mediaEntity.cover = cover;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    mediaEntity.createTime = createTime;
  }
  final int? duration = jsonConvert.convert<int>(json['duration']);
  if (duration != null) {
    mediaEntity.duration = duration;
  }
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    mediaEntity.id = id;
  }
  final int? resourceId = jsonConvert.convert<int>(json['resourceId']);
  if (resourceId != null) {
    mediaEntity.resourceId = resourceId;
  }

  final String? verifyState = jsonConvert.convert<String>(json['verifyState']);
  if (verifyState != null) {
    mediaEntity.verifyState = mediaStateFrom(verifyState);
  }

  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    mediaEntity.content = content;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    mediaEntity.updateTime = updateTime;
  }
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    mediaEntity.url = url;
  }
  return mediaEntity;
}

Map<String, dynamic> $MediaEntityToJson(MediaEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['cover'] = entity.cover;
  data['verifyState'] = entity.verifyState.toShortString();
  data['createTime'] = entity.createTime;
  data['duration'] = entity.duration;
  data['id'] = entity.id;
  data['resourceId'] = entity.resourceId;
  data['content'] = entity.content;
  data['updateTime'] = entity.updateTime;
  data['url'] = entity.url;
  return data;
}
