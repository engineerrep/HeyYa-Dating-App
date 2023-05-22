import 'dart:convert';

import 'package:heyya/generated/json/base/json_convert_content.dart';
import 'package:heyya/app/data/model/user_entity.dart';
import 'package:heyya/app/data/model/media_entity.dart';

UserEntity $UserEntityFromJson(Map<String, dynamic> json) {
  final UserEntity userEntity = UserEntity();
  final String? aboutMe = jsonConvert.convert<String>(json['aboutMe']);
  if (aboutMe != null) {
    userEntity.aboutMe = aboutMe;
  }
  final String? avatar = jsonConvert.convert<String>(json['avatar']);
  if (avatar != null) {
    userEntity.avatar = avatar;
  }
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    userEntity.id = id;
  }
  final String? nickname = jsonConvert.convert<String>(json['nickname']);
  if (nickname != null) {
    userEntity.nickname = nickname;
  }
  final String? sex = jsonConvert.convert<String>(json['sex']);
  if (sex != null) {
    userEntity.sex = sex;
  }
  final String? mainVideo = jsonConvert.convert<String>(json['mainVideo']);
  if (mainVideo != null) {
    userEntity.mainVideo = mainVideo;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    userEntity.updateTime = updateTime;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    userEntity.createTime = createTime;
  }
  final bool? liked = jsonConvert.convert<bool>(json['liked']);
  if (sex != null) {
    userEntity.liked = liked;
  }
  final bool? matchd = jsonConvert.convert<bool>(json['matchd']);
  if (sex != null) {
    userEntity.matchd = matchd;
  }
  final bool? passed = jsonConvert.convert<bool>(json['passed']);
  if (sex != null) {
    userEntity.passed = passed;
  }
  final String? phone = jsonConvert.convert<String>(json['phone']);
  if (phone != null) {
    userEntity.phone = phone;
  }
  final String? email = jsonConvert.convert<String>(json['email']);
  if (email != null) {
    userEntity.email = email;
  }
  final String? snapchat = jsonConvert.convert<String>(json['snapchat']);
  if (snapchat != null) {
    userEntity.snapchat = snapchat;
  }
  final String? instagram = jsonConvert.convert<String>(json['instagram']);
  if (instagram != null) {
    userEntity.instagram = instagram;
  }
  final String? tiktok = jsonConvert.convert<String>(json['tiktok']);
  if (tiktok != null) {
    userEntity.tiktok = tiktok;
  }
  final List<MediaEntity>? medias = jsonConvert.convertListNotNull<MediaEntity>(json['medias']);
  if (medias != null) {
    userEntity.medias = medias;
  }
  return userEntity;
}

Map<String, dynamic> $UserEntityToJson(UserEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['aboutMe'] = entity.aboutMe;
  data['avatar'] = entity.avatar;
  data['id'] = entity.id;
  data['nickname'] = entity.nickname;
  data['sex'] = entity.sex;
  data['medias'] = entity.medias?.map((v) => v.toJson()).toList();
  data['mainVideo'] = entity.mainVideo;
  data['updateTime'] = entity.updateTime;
  data['createTime'] = entity.createTime;
  data['liked'] = entity.liked;
  data['matchd'] = entity.matchd;
  data['passed'] = entity.passed;
  data['phone'] = entity.phone;
  data['email'] = entity.email;
  data['instagram'] = entity.instagram;
  data['snapchat'] = entity.snapchat;
  data['tiktok'] = entity.tiktok;
  return data;
}
