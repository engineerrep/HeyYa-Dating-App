enum VerifyState {
  UNCHECKED,
  CHECKED,
  REFUSE,
}

final verifyStateEnumMap = {
  VerifyState.UNCHECKED: "UNCHECKED",
  VerifyState.CHECKED: "CHECKED",
  VerifyState.REFUSE: "REFUSE"
};

VerifyState mediaTypeFrom(Object? source) {
  for (var entry in verifyStateEnumMap.entries) {
    if (entry.value == source) {
      return entry.key;
    }
  }
  return VerifyState.UNCHECKED;
}
