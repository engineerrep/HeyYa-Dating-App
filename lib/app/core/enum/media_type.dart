enum MediaType { PICTURE, VIDEO, VERIFY_VIDEO, MAIN_VIDEO }

///转文字
extension ParseToString on MediaType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

final mediaTypeEnumMap = {
  MediaType.PICTURE: "PICTURE",
  MediaType.VIDEO: "VIDEO",
  MediaType.VERIFY_VIDEO: "VERIFY_VIDEO",
  MediaType.MAIN_VIDEO: "MAIN_VIDEO"
};

MediaType mediaTypeFrom(Object? source) {
  for (var entry in mediaTypeEnumMap.entries) {
    if (entry.value == source) {
      return entry.key;
    }
  }
  return MediaType.PICTURE;
}
