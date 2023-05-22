import 'package:heyya/generated/json/base/json_convert_content.dart';
import 'package:heyya/app/data/model/relation_num_entity.dart';

RelationNumEntity $RelationNumEntityFromJson(Map<String, dynamic> json) {
	final RelationNumEntity relationNumEntity = RelationNumEntity();
	final int? likeMeNum = jsonConvert.convert<int>(json['likeMeNum']);
	if (likeMeNum != null) {
		relationNumEntity.likeMeNum = likeMeNum;
	}
	final int? matchNum = jsonConvert.convert<int>(json['matchNum']);
	if (matchNum != null) {
		relationNumEntity.matchNum = matchNum;
	}
	final int? myLikeNum = jsonConvert.convert<int>(json['myLikeNum']);
	if (myLikeNum != null) {
		relationNumEntity.myLikeNum = myLikeNum;
	}
	final int? visitorsNum = jsonConvert.convert<int>(json['visitorsNum']);
	if (visitorsNum != null) {
		relationNumEntity.visitorsNum = visitorsNum;
	}
	return relationNumEntity;
}

Map<String, dynamic> $RelationNumEntityToJson(RelationNumEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['likeMeNum'] = entity.likeMeNum;
	data['matchNum'] = entity.matchNum;
	data['myLikeNum'] = entity.myLikeNum;
	data['visitorsNum'] = entity.visitorsNum;
	return data;
}