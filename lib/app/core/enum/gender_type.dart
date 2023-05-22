enum GenderType { male, female }

String genderForDisplay(GenderType type) {
  switch (type) {
    case GenderType.female:
      return "Woman";
    case GenderType.male:
      return "Man";
  }
}

GenderType? genderType(String gender) {
  if (gender == genderValue(GenderType.female)) {
    return GenderType.female;
  } else if (gender == genderValue(GenderType.male)) {
    return GenderType.male;
  }
  return null;
}

String genderValue(GenderType type) {
  switch (type) {
    case GenderType.female:
      return "FEMALE";
    case GenderType.male:
      return "MALE";
  }
}
