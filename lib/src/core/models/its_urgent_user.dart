import 'package:its_urgent/src/core/models/user_ref.dart';


enum UserDocFields {
  name,
  imageUrl,
  deviceToken,
  uid,
  question,
  answer,
  answerType,
}

class ItsUrgentUser {
  final String name;
  final String imageUrl;
  final String deviceToken;
  final UserUid uid;
  final String question;
  final String answer;
  final String answerType;

  ItsUrgentUser(
      {required this.name,
      required this.imageUrl,
      required this.deviceToken,
      required this.uid,
      required this.question,
      required this.answer,
      required this.answerType,
      });

  @override
  String toString() {
    return """
    ItsUrgentUser(name: "$name", imageUrl: "$imageUrl", deviceToken: "$deviceToken, uid: "$uid", question: "$question", answer: "$answer", answerType: "$answerType")
    """;
  }

  factory ItsUrgentUser.fromJson(Map<String, dynamic> data) {
    return ItsUrgentUser(
      name: data[UserDocFields.name.name] ?? "No Name",
      imageUrl: data[UserDocFields.imageUrl.name] ?? "No Image",
      deviceToken: data[UserDocFields.deviceToken.name] ?? "0000",
      uid: data[UserDocFields.uid.name] ?? "No uid",
      question: data[UserDocFields.question.name] ?? "No question",
      answer: data[UserDocFields.answer.name] ?? "No answer",
      answerType: data[UserDocFields.answerType.name] ?? "No answer type",
    );
  }

   Map<String, dynamic> toJson(ItsUrgentUser user) {
    return {
      UserDocFields.name.name: user.name,
      UserDocFields.imageUrl.name: user.imageUrl,
      UserDocFields.deviceToken.name: user.deviceToken,
      UserDocFields.uid.name: user.uid,
      UserDocFields.question.name: user.question,
      UserDocFields.answer.name: user.answer,
      UserDocFields.answerType.name: user.answerType,
    };
  }

  ItsUrgentUser copyWith({
    String? name,
    String? imageUrl,
    String? deviceToken,
    UserUid? uid,
    String? question,
    String? answer,
    String? answerType,
    
  }) {
    return ItsUrgentUser(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      deviceToken: deviceToken ?? this.deviceToken,
      uid: uid ?? this.uid,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      answerType: answerType ?? this.answerType,
    );
  }
}
