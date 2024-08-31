import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/core/controllers/permissions_controller.dart';
import 'package:its_urgent/src/core/views/widgets/dnd_permissions_instruction_dialog.dart';

class DndOverridePermissionWidget extends ConsumerStatefulWidget {
  const DndOverridePermissionWidget({super.key});

  @override
  ConsumerState<DndOverridePermissionWidget> createState() =>
      _DndOverridePermissionsWidgetState();
}

class _DndOverridePermissionsWidgetState
    extends ConsumerState<DndOverridePermissionWidget>
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
      ref
          .read(dndInterruptionPermissionsController.notifier)
          .refreshPermissions();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final dndOvveridePermissions =
        ref.watch(dndInterruptionPermissionsController);

    return dndOvveridePermissions.when(
      data: (hasPermission) {
        return ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).colorScheme.primaryContainer,
                width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          leading: Icon(hasPermission
              ? Icons.do_not_disturb_off
              : Icons.do_not_disturb_on),
          title: Text(
            hasPermission
                ? 'Do Not Disturb Permissions granted'
                : 'Do Not Disturb Permissions denied',
          ),
          onTap: hasPermission
              ? null
              : () {
                  // ref
                  //     .read(deviceContactsPermissionsController.notifier)
                  //     .setContactPermission();
                  showDialog(
                      context: context,
                      useRootNavigator: false,
                      builder: (_) => const DndPermissionsInstructionDialog(
                          imagePath: 'assets/notifications.gif'));
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
        title: Text('Loading Do not disturb permissions...'),
        trailing: CircularProgressIndicator(),
      ),
      error: (error, _) => ListTile(
        title: Text('Failed to load permissions: $error'),
      ),
    );
  }
}
