import 'package:heyya/app/data/model/media_entity.dart';
import 'package:heyya/app/data/model/short_video_entity.dart';
import 'package:heyya/app/data/model/user_entity.dart';
import 'package:heyya/generated/json/base/json_convert_content.dart';

ShortVideoEntity $ShortVideoEntityFromJson(Map<String, dynamic> json) {
  final ShortVideoEntity shortVideoEntity = ShortVideoEntity();
  MediaEntity? video = jsonConvert.convert<MediaEntity>(json);
  video ??= jsonConvert.convert<MediaEntity>(json);
  if (video != null) {
    shortVideoEntity.video = video;
  }
  final UserEntity? user = jsonConvert.convert<UserEntity>(json['user']);
  if (user != null) {
    shortVideoEntity.user = user;
  }
  return shortVideoEntity;
}

Map<String, dynamic> $ShortVideoEntityToJson(ShortVideoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['video'] = entity.video?.toJson();
  data['user'] = entity.user?.toJson();
  return data;
}
