import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/commons/common_models/common_class_models/app_permissions.dart';

/// A controller to manage the permissions of the app using [Notifier].
class PermissionsController extends Notifier<AppPermissions> {
  @override
  AppPermissions build() {
    return AppPermissions(
      contactPermissions: const AsyncValue.data(false),
      notificationPermissions: const AsyncData(false),
      dndAccessPermissions: const AsyncData(false),
      isOnceAsked: false,
    );
  }

  void updatePermissions() {
    state = state.copyWith(
      contactPermissions: const AsyncData(true),
      notificationPermissions: const AsyncData(true),
      dndAccessPermissions: const AsyncData(true),
    );
  }

  Future<void> initPermissions() async {
    /// contact permissions
    final contactPermissions = await _requestContactsPermission();

    /// notification permissions
    bool notificationPermissions = await _requestNotificationPermission();

    state = state.copyWith(
      contactPermissions: AsyncValue.data(contactPermissions),
      notificationPermissions: AsyncData(notificationPermissions),
      isOnceAsked: true,
    );
  }

  Future<void> setContactPermission() async {
    state = state.copyWith(contactPermissions: const AsyncValue.loading());
    if (await _requestContactsPermission()) {
      state = state.copyWith(contactPermissions: const AsyncData(true));
      return;
    }else {
      await AppSettings.openAppSettings(type: AppSettingsType.settings);
      state = state.copyWith(contactPermissions: const AsyncData(false));
    }
    
  }

  Future<void> setNotificationPermission() async {
    state = state.copyWith(notificationPermissions: const AsyncValue.loading());

    if (await _requestNotificationPermission()) {
      state = state.copyWith(notificationPermissions: const AsyncData(true));
      return;
    } else {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
      state = state.copyWith(notificationPermissions: const AsyncData(false));
    }

    // try {
    //   // Your logic to request notification permission
    //   final permissionGranted = await Future.delayed(const Duration(seconds: 2),
    //       () => true); // Simulate a permission request
    //   state = state.copyWith(
    //       notificationPermissions: AsyncValue.data(permissionGranted));
    // } catch (e, st) {
    //   state = state.copyWith(notificationPermissions: AsyncValue.error(e, st));
    // }
  }

  Future<void> setDndAccessPermission() async {
    state = state.copyWith(dndAccessPermissions: const AsyncValue.loading());
    try {
      // Your logic to request DND access permission
      final permissionGranted = await Future.delayed(const Duration(seconds: 2),
          () => true); // Simulate a permission request
      state = state.copyWith(
          dndAccessPermissions: AsyncValue.data(permissionGranted));
    } catch (e, st) {
      state = state.copyWith(dndAccessPermissions: AsyncValue.error(e, st));
    }
  }

  /// private methods
  /// Request [FlutterContacts.requestPermission] to get the contact permission.
  Future<bool> _requestContactsPermission() =>
      FlutterContacts.requestPermission(readonly: true);

  /// Request [FirebaseMessaging.instance.requestPermission] to get the notification permission.
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

    final notificationPermissions = notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized;
    return notificationPermissions;
  }
}

/// A provider to provide the [PermissionsController] instance using [NotifierProvider].
final permissionsControllerProvider =
    NotifierProvider<PermissionsController, AppPermissions>(() {
  return PermissionsController();
});
