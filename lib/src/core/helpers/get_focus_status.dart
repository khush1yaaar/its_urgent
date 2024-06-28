import 'package:flutter/services.dart';
import 'package:focus_status/focus_status.dart';

Future<int> getFocusStatus() async {
  final focusStatusPlugin = FocusStatus();
  int focusStatusCode = 0;
  // Platform messages may fail, so we use a try/catch PlatformException.
  // We also handle the message potentially returning null.
  try {
    focusStatusCode = await focusStatusPlugin.getFocusStatus() ?? 0;
  } on PlatformException {
    focusStatusCode = 0;
  }
  print('Focus Status: $focusStatusCode');
  return focusStatusCode;
  
}
