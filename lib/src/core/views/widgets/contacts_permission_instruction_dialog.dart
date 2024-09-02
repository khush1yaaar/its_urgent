import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/core/controllers/permissions_controller.dart';
import 'package:its_urgent/src/core/views/widgets/elevated_button_with_icon.dart';

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
      await ref.read(permissionsController.notifier).refreshPermissions();
      if (ref.read(permissionsController).value?.contacts == true) {
        Navigator.of(context).pop();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Device Contacts Permissions'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: size.height * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      widget.imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'To follow these instructions, press the button below',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButtonWithIcon(
                    icon: const Icon(Icons.open_in_new_rounded),
                   
                    onPressed: () async {
                      await ref
                          .read(permissionsController.notifier)
                          .setContactPermission();
                    },
                    child: const Text('Grant Permissions'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
