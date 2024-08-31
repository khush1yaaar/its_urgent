import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/core/controllers/permissions_controller.dart';

class PermissionsTileWidget extends ConsumerStatefulWidget {
  final String permissionType;
  final String iconPath;
  final String grantedText;
  final String deniedText;
  final Widget? instructionDialog;

  const PermissionsTileWidget({
    super.key,
    required this.permissionType,
    required this.iconPath,
    required this.grantedText,
    required this.deniedText,
    required this.instructionDialog,
  });

  @override
  ConsumerState<PermissionsTileWidget> createState() =>
      _PermissionsWidgetState();
}

class _PermissionsWidgetState extends ConsumerState<PermissionsTileWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh permissions when the app resumes
      ref.read(permissionsController.notifier).refreshPermissions();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final permissionState = ref.watch(permissionsController);

    return permissionState.when(
      data: (permissions) {
        bool hasPermission;
        IconData icon;
        String text;
        void Function()? onTap;
        Future<void> Function()? requestPermission;

        switch (widget.permissionType) {
          case 'notification':
            hasPermission = permissions.notification;
            icon = hasPermission
                ? Icons.notifications_active
                : Icons.notifications_off;
            text = hasPermission ? widget.grantedText : widget.deniedText;
            onTap = hasPermission
                ? null
                : () {
                    ref
                        .read(permissionsController.notifier)
                        .setNotificationPermission();
                  };
            requestPermission = ref
                .read(permissionsController.notifier)
                .setNotificationPermission;
            break;

          case 'dnd':
            hasPermission = permissions.dnd;
            icon = hasPermission
                ? Icons.do_not_disturb_off
                : Icons.do_not_disturb_on;
            text = hasPermission ? widget.grantedText : widget.deniedText;
            onTap = hasPermission
                ? null
                : () {
                    showDialog(
                      context: context,
                      useRootNavigator: false,
                      builder: (_) => widget.instructionDialog!,
                    );
                  };
            requestPermission =
                ref.read(permissionsController.notifier).setDndAccessPermission;
            break;

          case 'contacts':
            hasPermission = permissions.contacts;
            icon = Icons.contacts;
            text = hasPermission ? widget.grantedText : widget.deniedText;
            onTap = hasPermission
                ? null
                : () {
                    showDialog(
                      context: context,
                      useRootNavigator: false,
                      builder: (_) => widget.instructionDialog!,
                    );
                  };
            requestPermission =
                ref.read(permissionsController.notifier).setContactPermission;
            break;

          default:
            hasPermission = false;
            icon = Icons.error;
            text = 'Unknown permission type';
            onTap = null;
            requestPermission = null;
        }

        return ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.primaryContainer,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          leading: Icon(icon),
          title: Text(text),
          onTap: onTap,
          trailing: Switch(
            value: hasPermission,
            onChanged: (bool? value) {
              if (value == true && requestPermission != null) {
                requestPermission();
              }
            },
          ),
        );
      },
      loading: () => const ListTile(
        title: Text('Loading permissions...'),
        trailing: CircularProgressIndicator(),
      ),
      error: (error, _) => ListTile(
        title: Text('Failed to load permissions: $error'),
      ),
    );
  }
}
