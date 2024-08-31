import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PermissionBoolController extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() async {
    log("Entered PermissionBoolController");
    return false;
  }
  // final permissions = await ref.read(permissionsControllerProvider.notifier).initPermissions();
  //   log("Permissions: $permissions");
  //   return permissions;
  // }

  void updatePermissions() {
    state = const AsyncData(true);
  }
}

final permissionBoolController =
    AsyncNotifierProvider<PermissionBoolController, bool>(() {
  return PermissionBoolController();
});
