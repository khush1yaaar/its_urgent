class CountryCodeItem {
  final String countryCode;
  final String phoneCode;
  final String name;
  final String flag;

  CountryCodeItem(
      {required this.countryCode,
      required this.phoneCode,
      required this.name,
      required this.flag});

  static CountryCodeItem fromJson(Map<String, String> data) {
    return CountryCodeItem(
      countryCode: data['countryCode']!,
      phoneCode: data['phoneCode']!,
      name: data['name']!,
      flag: data['flag']!,
    );
  }
}
