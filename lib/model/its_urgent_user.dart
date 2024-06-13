// will add more as the functionality grows
class ItsUrgentUser {
  final String name;
  final String imageUrl;

  ItsUrgentUser({required this.name, required this.imageUrl});

  @override
  String toString() {
    return 
    """
    ItsUrgentUser(name: "$name", imageUrl: "$imageUrl")
    """;
  }

  static ItsUrgentUser fromJson(Map<String, dynamic> data) {
    return ItsUrgentUser(
      name: data['name']!,
      imageUrl: data['imageUrl']!,
    );
  }

  static Map<String, String> toJson(ItsUrgentUser user) {
    return {
      'name': user.name,
      'imageUrl': user.imageUrl,
    };
  }
}
