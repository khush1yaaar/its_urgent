import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/core/controllers/permissions_controller.dart';
import 'package:its_urgent/src/core/views/widgets/contacts_permission_instruction_dialog.dart';
import 'package:its_urgent/src/core/views/widgets/dnd_permissions_instruction_dialog.dart';

import 'package:its_urgent/src/core/views/widgets/permissions_tile_widget.dart';

class PermissionsScreen extends ConsumerStatefulWidget {
  const PermissionsScreen({super.key});

  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen> {
  @override
  Widget build(BuildContext context) {
    final appPermissions = ref.watch(permissionsController);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/cropped_image.png',
                width: 250,
                height: 250,
              ),
              const SizedBox(
                width: double.infinity,
                height: 40,
              ),
              if (appPermissions.isLoading) ...[
                const Text("Checking permissions..."),
                const SizedBox(
                  height: 16,
                ),
                const CircularProgressIndicator(),
              ] else ...[
                Text(
                  "Please grant the following permissions to continue: ",
                  style: Theme.of(context).textTheme.bodyLarge!,
                ),
                const SizedBox(
                  height: 16,
                ),
                ListView(shrinkWrap: true, children: const [
                  PermissionsTileWidget(
                    permissionType: 'notification',
                    iconPath: 'assets/notifications.gif',
                    grantedText: 'Notifications are enabled',
                    deniedText: 'Notifications are disabled',
                    instructionDialog: null,
                  ),
                  SizedBox(height: 8),
                  PermissionsTileWidget(
                    permissionType: 'dnd',
                    iconPath: 'assets/dnd.gif',
                    grantedText: 'Do Not Disturb Permissions granted',
                    deniedText: 'Do Not Disturb Permissions denied',
                    instructionDialog: DndPermissionsInstructionDialog(
                      imagePath: 'assets/notifications.gif',
                    ),
                  ),
                  SizedBox(height: 8),
                  PermissionsTileWidget(
                    permissionType: 'contacts',
                    iconPath: 'assets/contacts.gif',
                    grantedText: 'Contacts Permissions granted',
                    deniedText: 'Contacts Permissions denied',
                    instructionDialog: ContactsPermissionInstructionDialog(
                      imagePath: 'assets/contacts.gif',
                    ),
                  ),
                ])
              ]
            ],
          ),
        ),
      ),
    );
  }
}
