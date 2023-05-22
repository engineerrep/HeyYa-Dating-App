enum FeedbackType {
  bug,
  question,
  ideas,
  billingQuestion,
}

extension ParseToString on FeedbackType {
  String toValue() {
    switch (this) {
      case FeedbackType.bug:
        return "BUG";
      case FeedbackType.question:
        return "QUESTION";
      case FeedbackType.ideas:
        return "IDEAS";
      case FeedbackType.billingQuestion:
        return "BILLING_QUESTIONS";
    }
  }

  String toDistplay() {
    switch (this) {
      case FeedbackType.bug:
        return "BUG";
      case FeedbackType.question:
        return "QUESTION";
      case FeedbackType.ideas:
        return "IDEAS";
      case FeedbackType.billingQuestion:
        return "BILLING_QUESTIONS";
    }
  }
}
