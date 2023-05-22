import 'package:heyya/app/core/enum/media_type.dart';
import 'package:heyya/app/data/model/media_entity.dart';
import 'package:heyya/app/data/model/user_entity.dart';
import 'package:heyya/app/data/session/session.dart';

//Video
extension UserEntityExt on UserEntity {
  bool hasMainVideo() {
    return mainVideo() != null;
  }

  MediaEntity? mainVideo() {
    if (medias != null) {
      for (var media in medias!) {
        if (media.type == MediaType.MAIN_VIDEO) {
          return media;
        }
      }
    }
    return null;
  }

  List<MediaEntity> verifiedVideos() {
    List<MediaEntity> verifiedVideos = [];
    if (medias != null) {
      for (var media in medias!) {
        if (media.type == MediaType.VERIFY_VIDEO) {
          verifiedVideos.add(media);
        }
      }
    }
    return verifiedVideos;
  }
}

extension UserExtension on UserEntity {
  bool isCurrentUser() {
    return (this.id == Session.getUser()?.id);
  }
}
