import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/core/controllers/permissions_controller.dart';

class NotificationPermissionsWidget extends ConsumerStatefulWidget {
  const NotificationPermissionsWidget({super.key});

  @override
  ConsumerState<NotificationPermissionsWidget> createState() =>
      _NotificationPermissionsWidgetState();
}

class _NotificationPermissionsWidgetState
    extends ConsumerState<NotificationPermissionsWidget>
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
      // Refresh notification permissions when the app resumes
      ref.read(notificationPermissionsController.notifier).refreshPermissions();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final notificationPermissions =
        ref.watch(notificationPermissionsController);

    return notificationPermissions.when(
      data: (hasPermission) {
        return ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).colorScheme.primaryContainer,
                width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          leading: Icon(
            hasPermission
                ? Icons.notifications_active
                : Icons.notifications_off,
          ),
          title: Text(
            hasPermission
                ? 'Notifications are enabled'
                : 'Notifications are disabled',
          ),
          onTap: hasPermission
              ? null
              : () {
                  ref
                      .read(notificationPermissionsController.notifier)
                      .setNotificationPermission();
                },
          trailing: Checkbox(
            value: hasPermission,
            onChanged: (bool? value) {
              // Update the state if the checkbox is toggled
            },
          ),
        );
      },
      loading: () => const ListTile(
        title: Text('Loading notification permissions...'),
        trailing: CircularProgressIndicator(),
      ),
      error: (error, _) => ListTile(
        title: Text('Failed to load permissions: $error'),
      ),
    );
  }
}
