import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/core/helpers/get_focus_status.dart';
import 'package:its_urgent/src/commons/common_providers/cloud_firestore_provider.dart';


class NotificationController {
  final FirebaseMessaging _firebaseMessaging;
  final ProviderRef _ref;

  const NotificationController(this._firebaseMessaging, this._ref);

  Future<void> setupToken() async {
    // Get the token each time the application loads
    String? token = await _firebaseMessaging.getToken();

    // Save the token to the database function from cloud firestore controller
    final saveToken = _ref.read(cloudFirestoreProvider).saveTokenToDatabase;

    // Save the initial token to the database
    await saveToken(token!);

    // Any time the token refreshes, store this in the database too.
    _firebaseMessaging.onTokenRefresh.listen(saveToken);
  }

  Future<bool> requestNotificationPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  // Foreground messages.
  void notificationForegroundListener() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("message title: ${message.notification?.title.toString()}");
      print("message body: ${message.notification?.body.toString()}");
      await getFocusStatus();
      
    },
    onError: (error) {
      print("error: $error");
    },
    onDone: () {
      print("done");
    });

  }
}

// Future<void> getBatteryLevel() async {
//   const platform = MethodChannel('com.hsiharki.itsurgent/battery');
//   try {
//     final int batteryLevel = await platform.invokeMethod('getFocusStatus');
//     print('Focus Status: $batteryLevel%');
//   } on PlatformException catch (e) {
//     print('Failed to get Focus Status: ${e.message}');
//   }
// }


