enum MediaState { UNCHECKED, CHECKED, REFUSE }

///转文字
extension MediaStateToString on MediaState {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

final mediaStateEnumMap = {
  MediaState.UNCHECKED: "UNCHECKED",
  MediaState.CHECKED: "CHECKED",
  MediaState.REFUSE: "REFUSE",
};

MediaState mediaStateFrom(Object? source) {
  for (var entry in mediaStateEnumMap.entries) {
    if (entry.value == source) {
      return entry.key;
    }
  }
  return MediaState.UNCHECKED;
}
