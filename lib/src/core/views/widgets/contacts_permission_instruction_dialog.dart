import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/core/controllers/permissions_controller.dart';

class ContactsPermissionInstructionDialog extends ConsumerStatefulWidget {
  final String imagePath;

  const ContactsPermissionInstructionDialog({
    super.key,
    required this.imagePath,
  });

  @override
  ConsumerState<ContactsPermissionInstructionDialog> createState() =>
      _ContactsPermissionInstructionDialogState();
}

class _ContactsPermissionInstructionDialogState
    extends ConsumerState<ContactsPermissionInstructionDialog>
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
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // Refresh notification permissions when the app resumes
    await  ref
          .read(deviceContactsPermissionsController.notifier)
          .refreshPermissions();
      if (ref.read(deviceContactsPermissionsController).value == true) {
        Navigator.of(context).pop();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog.fullscreen(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: Text("Device Contacts Permissions",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    textAlign: TextAlign.center),
              ),
              Image.asset(
                widget.imagePath,
                height: size.height * 0.7,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                'To follow these instructions, press the button below',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor:
                      Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                onPressed: () async {
                  await ref
                      .read(deviceContactsPermissionsController.notifier)
                      .setContactPermission();
                },
                child: const Text('Grant Permissions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
