enum ReportType {
  sendingSpam,
  scammer,
  inappropriateContent,
  rudeOrAbusive,
  stolenPhoto,
}

extension ParseToString on ReportType {
  String toValue() {
    switch (this) {
      case ReportType.scammer:
        return "SCAMMER";
      case ReportType.sendingSpam:
        return "SENDING_SPAM";
      case ReportType.rudeOrAbusive:
        return "RUDE_OR_ABUSIVE";
      case ReportType.inappropriateContent:
        return "INAPPROPRIATE_CONTENT";
      case ReportType.stolenPhoto:
        return "STOLEN_PHOTO";
    }
  }

  String toDistplay() {
    switch (this) {
      case ReportType.scammer:
        return "Scammer";
      case ReportType.sendingSpam:
        return "Sending Spam";
      case ReportType.stolenPhoto:
        return "Stolen Photos";
      case ReportType.rudeOrAbusive:
        return "Rude or Abusive";
      case ReportType.inappropriateContent:
        return "Inappropriate Content";
    }
  }
}
