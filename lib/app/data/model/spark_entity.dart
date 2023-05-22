import 'package:heyya/app/data/model/media_entity.dart';
import 'package:heyya/app/data/model/user_entity.dart';
import 'package:heyya/generated/json/base/json_field.dart';
import 'package:heyya/generated/json/spark_entity.g.dart';
import 'dart:convert';

import 'package:heyya/generated/json/user_entity.g.dart';

@JsonSerializable()
class SparkEntity {
  String? aboutMe = "";
  String? avatar = "";
  late String id = "";
  // late String province;
  // late String city;
  // late String country;
  // int? lat;
  // int? lon;
  late String createTime = "";
  List<MediaEntity> medias = List<MediaEntity>.empty();
  String? nickname = "";
  late String sex = "";
  late String updateTime = "";

  SparkEntity();

  factory SparkEntity.fromJson(Map<String, dynamic> json) =>
      $SparkEntityFromJson(json);

  Map<String, dynamic> toJson() => $SparkEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  //medias 后面会包含图片
  bool get hasMedia => medias.length > 0;
}

extension ToUserEntity on SparkEntity {
  UserEntity toUser() {
    return $UserEntityFromJson(this.toJson());
  }
}
