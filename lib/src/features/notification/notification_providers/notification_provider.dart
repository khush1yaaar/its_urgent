import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/features/notification/notification_controllers/notification_controller.dart';

final notificationInstanceProvider = Provider<NotificationController>((ref) {
  return NotificationController(FirebaseMessaging.instance, ref);
});
