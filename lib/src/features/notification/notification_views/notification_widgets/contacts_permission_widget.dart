import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/features/notification/notification_providers/device_contacts_provider.dart';
import 'package:its_urgent/src/features/notification/notification_views/notification_widgets/permission_button_widget.dart';

class ContactsPermissionWidget extends ConsumerWidget {
  const ContactsPermissionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PermissionButtonWidget(
            title: "Contacts Permissions Denied",
            subtitle:
                "Tap the Open App Settings Button below > Permissions > Contacts > Allow. Then tap here to refresh.",
            iconData: Icons.contacts,
            onPressed: () async {
              await ref.read(deviceContactsProvider.notifier).fetchContacts();
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
              onPressed: () {
                AppSettings.openAppSettings();
              },
              label: const Text("Open App Settings"),
              icon: const Icon(Icons.settings))
        ],
      ),
    );
  }
}
