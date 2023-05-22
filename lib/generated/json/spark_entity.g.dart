import 'package:heyya/generated/json/base/json_convert_content.dart';
import 'package:heyya/app/data/model/spark_entity.dart';
import 'package:heyya/app/data/model/media_entity.dart';

SparkEntity $SparkEntityFromJson(Map<String, dynamic> json) {
  final SparkEntity sparkEntity = SparkEntity();
  final String? aboutMe = jsonConvert.convert<String>(json['aboutMe']);
  if (aboutMe != null) {
    sparkEntity.aboutMe = aboutMe;
  }
  final String? avatar = jsonConvert.convert<String>(json['avatar']);
  if (avatar != null) {
    sparkEntity.avatar = avatar;
  }

  // final String? country = jsonConvert.convert<String>(json['country']);
  // if (country != null) {
  // 	sparkEntity.country = country;
  // }
  // final String? province = jsonConvert.convert<String>(json['province']);
  // if (province != null) {
  //   sparkEntity.province = province;
  // }
  // final String? city = jsonConvert.convert<String>(json['city']);
  // if (city != null) {
  // 	sparkEntity.city = city;
  // }
  // final int? lat = jsonConvert.convert<int>(json['lat']);
  // if (lat != null) {
  //   sparkEntity.lat = lat;
  // }
  // final int? lon = jsonConvert.convert<int>(json['lon']);
  // if (lon != null) {
  //   sparkEntity.lon = lon;
  // }
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    sparkEntity.id = id;
  }
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    sparkEntity.createTime = createTime;
  }
  final List<MediaEntity>? medias =
      jsonConvert.convertListNotNull<MediaEntity>(json['medias']);
  if (medias != null) {
    sparkEntity.medias = medias;
  }
  final String? nickname = jsonConvert.convert<String>(json['nickname']);
  if (nickname != null) {
    sparkEntity.nickname = nickname;
  }
  final String? sex = jsonConvert.convert<String>(json['sex']);
  if (sex != null) {
    sparkEntity.sex = sex;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    sparkEntity.updateTime = updateTime;
  }
  return sparkEntity;
}

Map<String, dynamic> $SparkEntityToJson(SparkEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['aboutMe'] = entity.aboutMe;
  data['avatar'] = entity.avatar;
  // data['province'] = entity.province;
  // data['city'] = entity.city;
  // data['country'] = entity.country;
  // data['lat'] = entity.lat;
  // data['lon'] = entity.lon;
  data['createTime'] = entity.createTime;
  data['id'] = entity.id;
  data['medias'] = entity.medias.map((v) => v.toJson()).toList();
  data['nickname'] = entity.nickname;
  data['sex'] = entity.sex;
  data['updateTime'] = entity.updateTime;
  return data;
}
