import 'package:heyya/app/data/model/media_entity.dart';

enum VideoPreviewType {
  sign, //注册时上传
  edit, //My Video编辑
  add, //My Video新增
  //profileAdd, //profile新增
  listAdd, //列表新增
}

class VideoPreviewModel {
  String? localURL;
  String? text;
  MediaEntity? video;
  bool? isOriginVideo;
  VideoPreviewType previewType;
  VideoPreviewModel(
      {required this.previewType,
      this.localURL,
      this.video,
      this.text,
      this.isOriginVideo});
}
