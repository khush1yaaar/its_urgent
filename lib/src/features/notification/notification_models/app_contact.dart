import 'package:its_urgent/src/core/models/its_urgent_user.dart';

class AppContact extends ItsUrgentUser {
  final String phoneNumber;

  AppContact({
    required super.name,
    required super.imageUrl,
    required super.deviceToken,
    required super.uid,
    required this.phoneNumber,
  });

  @override
  String toString() {
    return """
    AppContact(name: "$name", imageUrl: "$imageUrl", deviceToken: "$deviceToken", phoneNumber: "$phoneNumber, uid: "$uid")
    """;
  }
}
