import 'package:heyya/generated/json/base/json_convert_content.dart';
import 'package:heyya/app/core/base/response_list_entity.dart';

ResponseListEntity $ResponseListEntityFromJson(Map<String, dynamic> json) {
	final ResponseListEntity responseListEntity = ResponseListEntity();
	final int? code = jsonConvert.convert<int>(json['code']);
	if (code != null) {
		responseListEntity.code = code;
	}
	final String? msg = jsonConvert.convert<String>(json['msg']);
	if (msg != null) {
		responseListEntity.msg = msg;
	}
	final List<dynamic>? data = jsonConvert.convertListNotNull<dynamic>(json['data']);
	if (data != null) {
		responseListEntity.data = data;
	}
	return responseListEntity;
}

Map<String, dynamic> $ResponseListEntityToJson(ResponseListEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['code'] = entity.code;
	data['msg'] = entity.msg;
	data['data'] =  entity.data;
	return data;
}