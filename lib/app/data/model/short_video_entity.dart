import 'dart:convert';
import 'package:heyya/app/data/model/media_entity.dart';
import 'package:heyya/app/data/model/user_entity.dart';
import 'package:heyya/generated/json/base/json_field.dart';
import 'package:heyya/generated/json/short_video_entity.g.dart';

@JsonSerializable()
class ShortVideoEntity {
  MediaEntity? video;
  UserEntity? user;

  ShortVideoEntity();

  factory ShortVideoEntity.fromJson(Map<String, dynamic> json) =>
      $ShortVideoEntityFromJson(json);

  Map<String, dynamic> toJson() => $ShortVideoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
