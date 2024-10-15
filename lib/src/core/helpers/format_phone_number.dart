extension FormatPhoneNumber on String {
  String get formattedPhoneNumber {
    final RegExp regExp = RegExp(r'[^+\d]');
    return replaceAll(regExp, '');
  }
}