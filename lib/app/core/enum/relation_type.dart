enum RelationType {
  none,
  inMyFriendList,
  inOtherFriendList,
  bothWay,
}

final relationTypeEnumMap = {
  RelationType.none: "NONE",
  RelationType.inMyFriendList: "IN_MY_FRIEND_LIST",
  RelationType.inOtherFriendList: "IN_OTHER_FRIEND_LIST",
  RelationType.bothWay: "BOTH_WAY",
};

RelationType relationTypeFrom(Object? source) {
  for (var entry in relationTypeEnumMap.entries) {
    if (entry.value == source) {
      return entry.key;
    }
  }
  return RelationType.none;
}
