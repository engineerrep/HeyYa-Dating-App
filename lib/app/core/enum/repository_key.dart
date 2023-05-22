enum EditableKey {
  aboutMe,
  nickname,
  sex,
  avatar,
  phone,
  email,
  instagram,
  snapchat,
  tiktok
}

extension EditableKeyToString on EditableKey {
  String toShortString() {
    switch (this) {
      case EditableKey.aboutMe:
        return "aboutMe";
      case EditableKey.nickname:
        return "nickname";
      case EditableKey.avatar:
        return "avatar";
      case EditableKey.sex:
        return "sex";
      case EditableKey.phone:
        return "phone";
      case EditableKey.email:
        return "email";
      case EditableKey.instagram:
        return "instagram";
      case EditableKey.snapchat:
        return "snapchat";
      case EditableKey.tiktok:
        return "tiktok";
    }
  }
}
