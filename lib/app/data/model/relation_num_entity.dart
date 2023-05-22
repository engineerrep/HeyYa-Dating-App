import 'package:heyya/generated/json/base/json_field.dart';
import 'package:heyya/generated/json/relation_num_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class RelationNumEntity {

	late int likeMeNum;
	late int matchNum;
	late int myLikeNum;
	late int visitorsNum;
  
  RelationNumEntity();

  factory RelationNumEntity.fromJson(Map<String, dynamic> json) => $RelationNumEntityFromJson(json);

  Map<String, dynamic> toJson() => $RelationNumEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}