import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/core/helpers/helper_methods.dart';
import 'package:its_urgent/src/commons/common_providers/cloud_firestore_provider.dart';
import 'package:its_urgent/src/features/notification/notification_providers/cloud_function_provider.dart';

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
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');


      // If notification is received, then show the notification.
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification.toString()}');
        final notificationData = {
          'title': message.notification!.title,
          'body': message.notification!.body,
        };
        await showNotification(notificationData);
        
        // await showNotification(message.data);
      }

      // if data only message is received, then get the focus status & send the focus status back to the cloud function.
      if (message.data.isNotEmpty) {
        final type = message.data['type'];
        print('Type: $type');

        // get focus status & send the focus status back to the cloud function.
        if (type == notificationTypeMap[NotificationType.getFocusStatus].toString()) {
          final int focusStatus = await getFocusStatus();
          final senderUid = message.data['senderUid'];
          final receiverUid = message.data['receiverUid'];

          await sendFocusStatusToCloudFunction(
              focusStatus: focusStatus,
              senderUid: senderUid,
              receiverUid: receiverUid);
        }
      }

     
    }, onError: (error) {
      print("error: $error");
    }, onDone: () {
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





// const notificationTypes = {
//   100: "errorGettingFocusStatus",
//   99: "getFocusStatus",
//   98: "receivedSuccessfully",
//   97: "sentSuccessfully",
//   96: "dndOn",
//   2: "dndOn",
// };
