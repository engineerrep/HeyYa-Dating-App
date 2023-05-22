import 'package:heyya/generated/json/base/json_convert_content.dart';
import 'package:heyya/app/data/model/moment_entity.dart';
import 'package:heyya/app/data/model/media_entity.dart';

import 'package:heyya/app/data/model/user_entity.dart';


MomentEntity $MomentEntityFromJson(Map<String, dynamic> json) {
	final MomentEntity momentEntity = MomentEntity();
	final int? commentCount = jsonConvert.convert<int>(json['commentCount']);
	if (commentCount != null) {
		momentEntity.commentCount = commentCount;
	}
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		momentEntity.content = content;
	}
	final String? createTime = jsonConvert.convert<String>(json['createTime']);
	if (createTime != null) {
		momentEntity.createTime = createTime;
	}
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		momentEntity.id = id;
	}
	final bool? isThumb = jsonConvert.convert<bool>(json['isThumb']);
	if (isThumb != null) {
		momentEntity.isThumb = isThumb;
	}
	final List<MediaEntity>? medias = jsonConvert.convertListNotNull<MediaEntity>(json['medias']);
	if (medias != null) {
		momentEntity.medias = medias;
	}
	final int? thumbCount = jsonConvert.convert<int>(json['thumbCount']);
	if (thumbCount != null) {
		momentEntity.thumbCount = thumbCount;
	}
	final String? title = jsonConvert.convert<String>(json['title']);
	if (title != null) {
		momentEntity.title = title;
	}
	final String? updateTime = jsonConvert.convert<String>(json['updateTime']);
	if (updateTime != null) {
		momentEntity.updateTime = updateTime;
	}
	final UserEntity? user = jsonConvert.convert<UserEntity>(json['user']);
	if (user != null) {
		momentEntity.user = user;
	}
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		momentEntity.userId = userId;
	}
	return momentEntity;
}

Map<String, dynamic> $MomentEntityToJson(MomentEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['commentCount'] = entity.commentCount;
	data['content'] = entity.content;
	data['createTime'] = entity.createTime;
	data['id'] = entity.id;
	data['isThumb'] = entity.isThumb;
	data['medias'] =  entity.medias.map((v) => v.toJson()).toList();
	data['thumbCount'] = entity.thumbCount;
	data['title'] = entity.title;
	data['updateTime'] = entity.updateTime;
	data['user'] = entity.user.toJson();
	data['userId'] = entity.userId;
	return data;
}