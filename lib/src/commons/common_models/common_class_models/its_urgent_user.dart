// will add more as the functionality grows
class ItsUrgentUser {
  final String name;
  final String imageUrl;
  final String deviceToken;

  ItsUrgentUser({required this.name, required this.imageUrl, required this.deviceToken});

  @override
  String toString() {
    return """
    ItsUrgentUser(name: "$name", imageUrl: "$imageUrl", deviceToken: "$deviceToken")
    """;
  }

  factory ItsUrgentUser.fromJson (Map<String, dynamic> data) {
    return ItsUrgentUser(
      name: data['name']!,
      imageUrl: data['imageUrl']!,
      deviceToken: data['deviceToken']?? "0000",
    );
  }

  static Map<String, String> toJson(ItsUrgentUser user) {
    return {
      'name': user.name,
      'imageUrl': user.imageUrl,
      'deviceToken': user.deviceToken,
    };
  }
}
