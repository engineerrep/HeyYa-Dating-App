import 'package:heyya/generated/json/base/json_field.dart';
import 'package:heyya/generated/json/response_list_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class ResponseListEntity {

	late int code;
  late String msg;
  late List<dynamic> data;
  
  ResponseListEntity();

  factory ResponseListEntity.fromJson(Map<String, dynamic> json) => $ResponseListEntityFromJson(json);

  Map<String, dynamic> toJson() => $ResponseListEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}