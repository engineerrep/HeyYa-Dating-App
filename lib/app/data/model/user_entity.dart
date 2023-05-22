import 'package:heyya/app/data/model/media_entity.dart';
import 'package:heyya/generated/json/base/json_field.dart';
import 'package:heyya/generated/json/user_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class UserEntity {
  String? aboutMe = "";
  String? avatar = "";
  String? id = "";
  String? nickname = "";
  String? sex = "";
  String? mainVideo = "";
  String? updateTime = "";
  String? createTime = "";
  String? phone = "";
  String? email = "";
  String? tiktok = "";
  String? snapchat = "";
  String? instagram = "";

  bool? liked = false;
  bool? matchd = false;
  bool? passed = false;

  List<MediaEntity>? medias;

  UserEntity();

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      $UserEntityFromJson(json);

  Map<String, dynamic> toJson() => $UserEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  @override
  int get hashCode =>
      aboutMe.hashCode ^
      avatar.hashCode ^
      id.hashCode ^
      nickname.hashCode ^
      sex.hashCode ^
      mainVideo.hashCode ^
      updateTime.hashCode ^
      createTime.hashCode ^
      liked.hashCode ^
      matchd.hashCode ^
      phone.hashCode ^
      email.hashCode ^
      snapchat.hashCode ^
      instagram.hashCode ^
      tiktok.hashCode ^
      passed.hashCode;

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          aboutMe == other.aboutMe &&
          avatar == other.avatar &&
          id == other.id &&
          nickname == other.nickname &&
          sex == other.sex &&
          mainVideo == other.mainVideo &&
          updateTime == other.updateTime &&
          createTime == other.createTime &&
          liked == other.liked &&
          matchd == other.matchd &&
          phone == other.phone &&
          email == other.email &&
          instagram == other.instagram &&
          snapchat == other.snapchat &&
          tiktok == other.tiktok &&
          passed == other.passed;
}
