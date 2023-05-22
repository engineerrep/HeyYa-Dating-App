import 'package:heyya/app/data/model/user_entity.dart';
import 'package:heyya/generated/json/base/json_field.dart';
import 'package:heyya/generated/json/account_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class AccountEntity {

	late String createTime;
	late String id;
	late UserEntity user;
	late String account;
	late String token;
	late String sig;
  late String type;



  AccountEntity();

  factory AccountEntity.fromJson(Map<String, dynamic> json) => $AccountEntityFromJson(json);

  Map<String, dynamic> toJson() => $AccountEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
