import 'package:flutter_riverpod/flutter_riverpod.dart';


// This notifier & notifier provider keep track of whether to show the splash screen or no while redirecting routes

class SplashScreenBoolean extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void onSplashScreenRemoved() {
    state = true;
  }
}

final splashScreenBooleanProvider =
    NotifierProvider<SplashScreenBoolean, bool>(() {
  return SplashScreenBoolean();
});
