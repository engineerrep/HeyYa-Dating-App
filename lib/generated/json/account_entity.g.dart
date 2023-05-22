import 'package:heyya/generated/json/base/json_convert_content.dart';
import 'package:heyya/app/data/model/account_entity.dart';
import 'package:heyya/app/data/model/user_entity.dart';


AccountEntity $AccountEntityFromJson(Map<String, dynamic> json) {
	final AccountEntity accountEntity = AccountEntity();
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		accountEntity.createTime = createTime;
	}
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		accountEntity.id = id;
	}
	final UserEntity? user = jsonConvert.convert<UserEntity>(json['user']);
	if (user != null) {
		accountEntity.user = user;
	}
	final String? account = jsonConvert.convert<String>(json['account']);
	if (account != null) {
		accountEntity.account = account;
	}
	final String? token = jsonConvert.convert<String>(json['token']);
	if (token != null) {
		accountEntity.token = token;
	}
	final String? sig = jsonConvert.convert<String>(json['sig']);
	if (sig != null) {
		accountEntity.sig = sig;
	}
	final String? type = jsonConvert.convert<String>(json['type']);
	if (type != null) {
		accountEntity.type = type;
	}
	return accountEntity;
}

Map<String, dynamic> $AccountEntityToJson(AccountEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['createTime'] = entity.createTime;
	data['id'] = entity.id;
	data['user'] = entity.user.toJson();
	data['account'] = entity.account;
	data['token'] = entity.token;
	data['sig'] = entity.sig;
	data['type'] = entity.type;
	return data;
}