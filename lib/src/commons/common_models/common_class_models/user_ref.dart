class UserRef {
  final String uid;
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
      uid: data['uid']!,
      phoneNumber: data['phoneNumber']!,
    );
  }

  static Map<String, String> toJson(UserRef user) {
    return {
      'uid': user.uid,
      'phoneNumber': user.phoneNumber,
    };
  }
  
}
