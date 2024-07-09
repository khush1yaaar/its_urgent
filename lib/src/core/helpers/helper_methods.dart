import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
import 'package:focus_status/focus_status.dart';
import 'package:its_urgent/src/commons/common_models/common_class_models/user_ref.dart';

/// helper constants
enum NotificationType {
  userNotFound,
  errorGettingFocusStatus,
  getFocusStatus,
  receivedSuccessfully,
  sentSuccessfully,
  dndOn,
}

const notificationTypeMap = {
  NotificationType.userNotFound: 101,
  NotificationType.errorGettingFocusStatus: 100,
  NotificationType.getFocusStatus: 99,
  NotificationType.receivedSuccessfully: 98,
  NotificationType.sentSuccessfully: 97,
  NotificationType.dndOn: 96,
};



/// The methods in this file are defined directly, so that they can be used both in the foreground and background message handlers.


/// Get the focus status of the user.
/// This functions is used by both the foreground and background message handlers.
Future<int> getFocusStatus() async {
  /// Create an instance of the FocusStatus plugin
  /// This plugin is created by me and is available on [https://github.com/0xharkirat/focus_status]
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

Future<void> showNotification(Map<String, dynamic> notificationData) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: 1010,
    channelKey: 'basic_channel',
    title: notificationData['title'],
    body: notificationData['body'],
    wakeUpScreen: true,
    

  ));

  

  // await AwesomeNotifications().createNotificationFromJsonData(notificationData);
}



 // this function is called to send focus status to the cloud function & show notification accordingly.
  Future <void> sendFocusStatusToCloudFunction({required int focusStatus, required UserUid senderUid, required UserUid receiverUid, bool bypass = false}) async {
    final data = {
      'focusStatus': focusStatus,
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'bypass': bypass,
    };

    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendNotification');
    try {
      final HttpsCallableResult result = await callable(data);
      print(result.data);
    } catch (e) {
      print('Exception: $e');
    }
  }
