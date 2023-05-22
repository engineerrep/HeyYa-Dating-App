import 'package:heyya/generated/json/base/json_field.dart';
import 'package:heyya/generated/json/response_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class ResponseEntity {

	late int code;
	late Map<String,dynamic> data;
	late String msg;
  
  ResponseEntity();

  factory ResponseEntity.fromJson(Map<String, dynamic> json) => $ResponseEntityFromJson(json);

  Map<String, dynamic> toJson() => $ResponseEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ResponseData {


  
  ResponseData();

  factory ResponseData.fromJson(Map<String, dynamic> json) => $ResponseDataFromJson(json);

  Map<String, dynamic> toJson() => $ResponseDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}