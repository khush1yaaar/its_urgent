typedef UserUid = String;

enum UserRefFields {
  uid,
  phoneNumber,
}

class UserRef {
  final UserUid uid;
  final String phoneNumber;

  const UserRef({required this.uid, required this.phoneNumber});

  @override
  String toString() {
    return """
    UserRef(uid: "$uid", phoneNumber: "$phoneNumber")
    """;
  }

  factory UserRef.fromJson(Map<String, dynamic> data) {
    return UserRef(
      uid: data[UserRefFields.uid.name]!,
      phoneNumber: data[UserRefFields.phoneNumber.name]!,
    );
  }

  static Map<String, String> toJson(UserRef user) {
    return {
      UserRefFields.uid.name: user.uid,
      UserRefFields.phoneNumber.name: user.phoneNumber,
    };
  }
}
