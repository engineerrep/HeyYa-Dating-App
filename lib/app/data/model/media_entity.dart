import 'dart:convert';

import 'package:heyya/app/core/enum/media_state.dart';
import 'package:heyya/app/core/enum/media_type.dart';
import 'package:heyya/generated/json/base/json_field.dart';
import 'package:heyya/generated/json/media_entity.g.dart';

class MediaSaveEntity {
  final String? cover;
  final int? duration;
  final int? resourceId;
  final MediaType type;
  final String url;

  MediaSaveEntity({
    required this.type,
    required this.url,
    this.cover,
    this.duration,
    this.resourceId,
  });

  @override
  int get hashCode =>
      cover.hashCode ^
      duration.hashCode ^
      resourceId.hashCode ^
      type.hashCode ^
      url.hashCode;

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is MediaSaveEntity &&
          runtimeType == other.runtimeType &&
          cover == other.cover &&
          duration == other.duration &&
          resourceId == other.resourceId &&
          type == other.type &&
          url == other.url;

  Map<String, dynamic> toJson() {
    return {
      'cover': cover,
      'duration': duration,
      'resourceId': resourceId,
      'type': mediaTypeEnumMap[type],
      'url': url,
    };
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class MediaEntity {
  late String createTime;
  int? duration = 0;
  late String id;
  late int resourceId;
  String? content = '';
  @JSONField(deserialize: false, serialize: false)
  late MediaType type;
  late MediaState verifyState;
  late String updateTime;
  String url = '';
  String? cover = '';

  MediaEntity();

  static MediaEntity sparkMedia() {
    final entity = MediaEntity();
    entity.content = '';
    entity.cover = '';
    entity.createTime = '';
    entity.duration = 0;
    entity.id = '';
    entity.resourceId = 0;
    entity.type = MediaType.VIDEO;
    entity.updateTime = '';
    entity.url = '';
    return entity;
  }

  @override
  int get hashCode =>
      cover.hashCode ^
      createTime.hashCode ^
      duration.hashCode ^
      id.hashCode ^
      resourceId.hashCode ^
      type.hashCode ^
      verifyState.hashCode ^
      updateTime.hashCode ^
      content.hashCode ^
      url.hashCode;

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is MediaEntity &&
          runtimeType == other.runtimeType &&
          cover == other.cover &&
          createTime == other.createTime &&
          duration == other.duration &&
          id == other.id &&
          resourceId == other.resourceId &&
          type == other.type &&
          verifyState == other.verifyState &&
          updateTime == other.updateTime &&
          url == other.url;

  factory MediaEntity.fromJson(Map<String, dynamic> srcJson) {
    final entity = $MediaEntityFromJson(srcJson);
    entity.type = mediaTypeFrom(srcJson['type']);
    return entity;
  }

  Map<String, dynamic> toJson() {
    final json = $MediaEntityToJson(this);
    json['type'] = mediaTypeEnumMap[type];
    return json;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
