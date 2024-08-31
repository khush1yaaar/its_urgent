import 'package:its_urgent/src/core/models/user_ref.dart';

enum UserDocFields {
  name,
  imageUrl,
  deviceToken,
  uid,
}

class ItsUrgentUser {
  final String name;
  final String imageUrl;
  final String deviceToken;
  final UserUid uid;

  ItsUrgentUser(
      {required this.name, required this.imageUrl, required this.deviceToken, required this.uid});

  @override
  String toString() {
    return """
    ItsUrgentUser(name: "$name", imageUrl: "$imageUrl", deviceToken: "$deviceToken, uid: "$uid")
    """;
  }

  factory ItsUrgentUser.fromJson(Map<String, dynamic> data) {
    return ItsUrgentUser(
      name: data[UserDocFields.name.name] ?? "No Name",
      imageUrl: data[UserDocFields.imageUrl.name] ?? "No Image",
      deviceToken: data[UserDocFields.deviceToken.name] ?? "0000",
      uid: data[UserDocFields.uid.name] ?? "No uid",
    );
  }

  static Map<String, String> toJson(ItsUrgentUser user) {
    return {
      UserDocFields.name.name: user.name,
      UserDocFields.imageUrl.name: user.imageUrl,
      UserDocFields.deviceToken.name: user.deviceToken,
      UserDocFields.uid.name: user.uid,
    };
  }

  ItsUrgentUser copyWith({
    String? name,
    String? imageUrl,
    String? deviceToken,
    UserUid? uid,
  }) {
    return ItsUrgentUser(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      deviceToken: deviceToken ?? this.deviceToken,
      uid: uid ?? this.uid,
    );
  }
}
