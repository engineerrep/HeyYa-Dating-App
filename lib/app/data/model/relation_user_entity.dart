import 'package:heyya/app/data/model/user_entity.dart';
import 'package:heyya/generated/json/base/json_field.dart';
import 'package:heyya/generated/json/relation_user_entity.g.dart';
import 'dart:convert';
import 'package:heyya/app/core/enum/relation_type.dart';

@JsonSerializable()
class RelationUserEntity {
  late String createTime;
  late String id;
  @JSONField(deserialize: false, serialize: false)
  late RelationType relation;
  late UserEntity toUser;
  late String updateTime;

  RelationUserEntity();

  factory RelationUserEntity.fromJson(Map<String, dynamic> json) {
    final entity = $RelationUserEntityFromJson(json);
    entity.relation = relationTypeFrom(json['relation']);
    return entity;
  }

  Map<String, dynamic> toJson() {
    final json = $RelationUserEntityToJson(this);
    json['relation'] = relationTypeEnumMap[relation];
    return json;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
