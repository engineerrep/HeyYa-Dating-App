import 'package:heyya/generated/json/base/json_convert_content.dart';
import 'package:heyya/app/data/model/relation_user_entity.dart';
import 'package:heyya/app/data/model/user_entity.dart';

import 'package:heyya/app/core/enum/relation_type.dart';

RelationUserEntity $RelationUserEntityFromJson(Map<String, dynamic> json) {
  final RelationUserEntity relationUserEntity = RelationUserEntity();
  final String? createTime = jsonConvert.convert<String>(json['createTime']);
  if (createTime != null) {
    relationUserEntity.createTime = createTime;
  }
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    relationUserEntity.id = id;
  }
  final UserEntity? toUser = jsonConvert.convert<UserEntity>(json['toUser']);
  if (toUser != null) {
    relationUserEntity.toUser = toUser;
  }
  final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
  if (updateTime != null) {
    relationUserEntity.updateTime = updateTime;
  }
  return relationUserEntity;
}

Map<String, dynamic> $RelationUserEntityToJson(RelationUserEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['createTime'] = entity.createTime;
  data['id'] = entity.id;
  data['toUser'] = entity.toUser.toJson();
  data['updateTime'] = entity.updateTime;
  return data;
}
