import 'package:heyya/generated/json/base/json_convert_content.dart';
import 'package:heyya/app/core/base/response_entity.dart';

ResponseEntity $ResponseEntityFromJson(Map<String, dynamic> json) {
	final ResponseEntity responseEntity = ResponseEntity();
	final int? code = jsonConvert.convert<int>(json['code']);
	if (code != null) {
		responseEntity.code = code;
	}
	final Map<String,dynamic>? data = jsonConvert.convert<Map<String,dynamic>>(json['data']);
	if (data != null) {
		responseEntity.data = data;
	}
	final String? msg = jsonConvert.convert<String>(json['msg']);
	if (msg != null) {
		responseEntity.msg = msg;
	}
	return responseEntity;
}

Map<String, dynamic> $ResponseEntityToJson(ResponseEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['code'] = entity.code;
	data['data'] = entity.data;
	data['msg'] = entity.msg;
	return data;
}

ResponseData $ResponseDataFromJson(Map<String, dynamic> json) {
	final ResponseData responseData = ResponseData();
	return responseData;
}

Map<String, dynamic> $ResponseDataToJson(ResponseData entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	return data;
}