enum LogInType {
  APPLEID,
  GOOGLE,
  DEVICE,
}

extension ParseToString on LogInType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
