import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/core/controllers/permissions_controller.dart';
import 'package:its_urgent/src/core/views/widgets/contacts_permission_instruction_dialog.dart';

class DeviceContactsPermissionsWidget extends ConsumerStatefulWidget {
  const DeviceContactsPermissionsWidget({super.key});

  @override
  ConsumerState<DeviceContactsPermissionsWidget> createState() =>
      _DeviceContactsPermissionsWidgetState();
}

class _DeviceContactsPermissionsWidgetState
    extends ConsumerState<DeviceContactsPermissionsWidget>
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
          .read(deviceContactsPermissionsController.notifier)
          .refreshPermissions();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final deviceContactsPermissions =
        ref.watch(deviceContactsPermissionsController);

    return deviceContactsPermissions.when(
      data: (hasPermission) {
        return ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).colorScheme.primaryContainer,
                width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          leading: const Icon(Icons.contacts),
          title: Text(
            hasPermission
                ? 'Contacts Permissions granted'
                : 'Contacts Permissions denied',
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
                      builder: (_) => const ContactsPermissionInstructionDialog(
                          imagePath: 'assets/contacts.gif'));
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
        title: Text('Loading Contacts permissions...'),
        trailing: CircularProgressIndicator(),
      ),
      error: (error, _) => ListTile(
        title: Text('Failed to load permissions: $error'),
      ),
    );
  }
}
