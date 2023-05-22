import 'package:heyya/app/data/model/media_entity.dart';
import 'package:heyya/app/data/model/user_entity.dart';
import 'package:heyya/generated/json/base/json_field.dart';
import 'package:heyya/generated/json/moment_entity.g.dart';
import 'dart:convert';

import 'package:heyya/generated/json/user_entity.g.dart';

class MomentSaveEntity {
  final String? content;
  final List<MediaSaveEntity> medias;
  final String? title;
  final int userId;

  MomentSaveEntity({
    required this.userId,
    required this.medias,
    this.title,
    this.content,
  });

  Map<String, dynamic> toJson() => {
        'content': content,
        'medias': medias.map((v) => v.toJson()).toList(),
        'title': title,
        'userId': userId,
      };
}

@JsonSerializable()
class MomentEntity {
  late int commentCount;
  late String content;
  late String createTime;
  late String id;
  late bool isThumb;
  late List<MediaEntity> medias = [];
  late int thumbCount;
  late String title;
  late String updateTime;
  late UserEntity user;
  late String userId;

  MomentEntity();

  factory MomentEntity.fromJson(Map<String, dynamic> json) =>
      $MomentEntityFromJson(json);

  Map<String, dynamic> toJson() => $MomentEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  @override
  int get hashCode =>
      commentCount.hashCode ^
      content.hashCode ^
      createTime.hashCode ^
      id.hashCode ^
      isThumb.hashCode ^
      medias.hashCode ^
      thumbCount.hashCode ^
      title.hashCode ^
      updateTime.hashCode ^
      user.hashCode ^
      userId.hashCode;

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is MomentEntity &&
          runtimeType == other.runtimeType &&
          commentCount == other.commentCount &&
          content == other.content &&
          createTime == other.createTime &&
          id == other.id &&
          isThumb == other.isThumb &&
          medias == other.medias &&
          thumbCount == other.thumbCount &&
          title == other.title &&
          updateTime == other.updateTime &&
          user == other.user &&
          userId == other.userId;

  MomentEntity copyWith(
      {int? commentCount,
      List<MediaEntity>? medias,
      bool? isThumb,
      int? thumbCount}) {
    final entity = MomentEntity();
    entity.commentCount = commentCount ?? this.commentCount;
    entity.content = content;
    entity.createTime = createTime;
    entity.id = id;
    entity.isThumb = isThumb ?? this.isThumb;
    entity.medias = medias ?? this.medias;
    entity.thumbCount = thumbCount ?? this.thumbCount;
    entity.updateTime = updateTime;
    entity.user = user;
    entity.userId = userId;
    return entity;
  }
}

extension ToUserEntity on MomentEntity {
  UserEntity toUser() {
    return $UserEntityFromJson(this.user.toJson());
  }
}
