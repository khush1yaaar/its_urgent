import 'dart:async';
import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/core/models/permissions_state.dart';

class PermissionsController extends AsyncNotifier<PermissionsState> {
  @override
  FutureOr<PermissionsState> build() async {
    return await _fetchPermissions();
  }

  Future<PermissionsState> _fetchPermissions() async {
    final notificationPermissions = await _requestNotificationPermission();
    final contactPermissions = await _requestContactsPermission();
    final dndInterruptionPermissions = await _getDNDStatus();

    final allPermissionsGranted = notificationPermissions &&
        contactPermissions &&
        dndInterruptionPermissions;

    // Update the allPermissionsGrantedProvider state
    ref.read(allPermissionsGrantedProvider.notifier).state =
        allPermissionsGranted;

    return PermissionsState(
      notification: notificationPermissions,
      contacts: contactPermissions,
      dnd: dndInterruptionPermissions,
    );
  }

  Future<void> refreshPermissions() async {
    state = AsyncData(await _fetchPermissions());
  }

  Future<void> setNotificationPermission() async {
    final hasPermission = await _requestNotificationPermission();
    final currentState = state.value ??
        PermissionsState(
          notification: false,
          contacts: false,
          dnd: false,
        );
    state = AsyncData(currentState.copyWith(notification: hasPermission));

    if (!hasPermission) {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  Future<void> setContactPermission() async {
    final hasPermission = await _requestContactsPermission();
    final currentState = state.value ??
        PermissionsState(
          notification: false,
          contacts: false,
          dnd: false,
        );
    state = AsyncData(currentState.copyWith(contacts: hasPermission));

    if (!hasPermission) {
      await AppSettings.openAppSettings(type: AppSettingsType.settings);
    }
  }

  Future<void> setDndAccessPermission() async {
    final hasPermission = await _getDNDStatus();
    final currentState = state.value ??
        PermissionsState(
          notification: false,
          contacts: false,
          dnd: false,
        );
    state = AsyncData(currentState.copyWith(dnd: hasPermission));

    if (!hasPermission) {
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

  Future<bool> _requestContactsPermission() async {
    
    return await FlutterContacts.requestPermission(readonly: true);
  }

  Future<bool> _getDNDStatus() async {
    const platform = MethodChannel('com.hsiharki.itsurgent/battery');
    final dnd = await platform.invokeMethod<bool>('canBypassDnd');
    log("DND permissions: $dnd");
    return dnd ?? false;
  }
}

final permissionsController =
    AsyncNotifierProvider<PermissionsController, PermissionsState>(
  () => PermissionsController(),
);




/// Provider to keep track of all permissions granted
final allPermissionsGrantedProvider = StateProvider<bool>((ref) {
  // Initial value could be false, or you could calculate based on an initial check.
  return false;
});
