import 'dart:async';
import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_status/focus_status.dart';
import 'package:its_urgent/src/core/models/app_permissions.dart';


/// A controller to manage the notification permissions of the app using [AsyncNotifier].
class NotificationPermissionsController extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() async {
    return await _requestNotificationPermission();
  }

  Future<void> refreshPermissions() async {
    final notificationPermissions = await _requestNotificationPermission();
    state = AsyncData(notificationPermissions);
  }

  Future<void> setNotificationPermission() async {
    if (await _requestNotificationPermission()) {
      state = const AsyncData(true);
    } else {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  Future<bool> _requestNotificationPermission() async {
    final notificationSettings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized;
  }
}

final notificationPermissionsController =
    AsyncNotifierProvider<NotificationPermissionsController, bool>(() {
  return NotificationPermissionsController();
});


/// A controller to manage the device contacts permissions of the app using [AsyncNotifier].
class DeviceContactsPermissionsController extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() async {
    return await _requestContactsPermission();
  }

  Future<void> refreshPermissions() async {
    final contactPermissions = await _requestContactsPermission();
    state = AsyncData(contactPermissions);
  }

  Future<void> setContactPermission() async {
    if (await _requestContactsPermission()) {
      state = const AsyncData(true);
    } else {
      await AppSettings.openAppSettings(type: AppSettingsType.settings);
    }
  }

  Future<bool> _requestContactsPermission() =>
      FlutterContacts.requestPermission(readonly: true);
}

final deviceContactsPermissionsController =
    AsyncNotifierProvider<DeviceContactsPermissionsController, bool>(() {
  return DeviceContactsPermissionsController();
});


/// A controller to manage the DND permissions of the app using [AsyncNotifier].
class DndInterruptionPermissionsController extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() async {
    return await _getDNDStatus();
  }

  Future<void> refreshPermissions() async {
    final dndInterruptionPermissions = await _getDNDStatus();
    state = AsyncData(dndInterruptionPermissions);
  }

  Future<void> setDndAccessPermission() async {
   if (await _getDNDStatus()) {
      state = const AsyncData(true);
    } else {
      await AppSettings.openAppSettings(type: AppSettingsType.settings);
    }
  }

  Future<bool> _getDNDStatus() async {
    const platform = MethodChannel('com.hsiharki.itsurgent/battery');

    final dnd = await platform.invokeMethod<bool>('canBypassDnd');
    log("dnd permissions: $dnd");
    return dnd ?? false;
  }
}

final dndInterruptionPermissionsController =
    AsyncNotifierProvider<DndInterruptionPermissionsController, bool>(() {
  return DndInterruptionPermissionsController();
});