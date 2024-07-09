import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppPermissions {
  final AsyncValue<bool> contactPermissions;
  final AsyncValue<bool> notificationPermissions;
  final AsyncValue<bool> dndAccessPermissions;
  final bool isOnceAsked;

  AppPermissions({
    required this.contactPermissions,
    required this.notificationPermissions,
    required this.dndAccessPermissions,
    required this.isOnceAsked,
  });

  AppPermissions copyWith({
    AsyncValue<bool>? contactPermissions,
    AsyncValue<bool>? notificationPermissions,
    AsyncValue<bool>? dndAccessPermissions,
    bool? isOnceAsked,
  }) {
    return AppPermissions(
      contactPermissions: contactPermissions ?? this.contactPermissions,
      notificationPermissions:
          notificationPermissions ?? this.notificationPermissions,
      dndAccessPermissions: dndAccessPermissions ?? this.dndAccessPermissions,
      isOnceAsked: isOnceAsked ?? this.isOnceAsked,
    );
  }

  @override
  String toString() =>
      'Permissions(contactPermissions: $contactPermissions, notificationPermissions: $notificationPermissions, dndAccessPermission: $dndAccessPermissions)';
}
