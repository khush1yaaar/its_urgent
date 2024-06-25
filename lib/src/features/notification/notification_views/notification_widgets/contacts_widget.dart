import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/features/notification/notification_providers/device_contacts_provider.dart';
import 'package:its_urgent/src/features/notification/notification_views/notification_widgets/contacts_permission_widget.dart';
import 'package:its_urgent/src/features/notification/notification_views/notification_widgets/empty_contacts_widget.dart';

class ContactsWidget extends ConsumerWidget {
  const ContactsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final fruits = List<String>.generate(50, (i) => 'Fruit $i');
    // final vegies = List<String>.generate(50, (i) => 'Vegies $i');
    final contactsProvider = ref.watch(deviceContactsProvider);

    // Check if permission is denied
    if (contactsProvider.permissionDenied) {
      return const ContactsPermissionWidget();
    }

    // Check if contacts are still loading
    if (contactsProvider.allDeviceContacts == null ||
        contactsProvider.appContacts == null ||
        contactsProvider.nonAppContacts == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Check if no contacts are found on the device
    if (contactsProvider.allDeviceContacts!.isEmpty) {
      return const EmptyContactsWidget(
        errorText:
            "No contacts found on your device. Add atleast one contact to your device to see it here.",
      );
    }

    // Check if no contacts are found on the app database
    if (contactsProvider.appContacts!.isEmpty) {
      return const EmptyContactsWidget(
        errorText:
            "Error fetching contacts from database. Please try again later.",
      );
    }

    // Everything runs fine
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your contacts on It's Urgent",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            const SizedBox(
              height: 4,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: contactsProvider.appContacts!.length,
              itemBuilder: (context, i) {
                final contact = contactsProvider.appContacts![i];
                return ListTile(
                  title: Text(
                    contact.name,
                    textAlign: TextAlign.left,
                  ),
                  onTap: () async {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (_) => ContactPage(contact),
                    // ));
                  },
                );
              },
            ),
            Text(
              "Invite to It's Urgent",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            const SizedBox(
              height: 4,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: contactsProvider.nonAppContacts!.length,
              itemBuilder: (context, i) {
                final contact = contactsProvider.nonAppContacts![i];
                return ListTile(
                  title: Text(
                    contact.name,
                    textAlign: TextAlign.left,
                  ),
                  subtitle: Text(
                    contact.phoneNumber,
                    textAlign: TextAlign.left,
                  ),
                  onTap: () async {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (_) => ContactPage(contact),
                    // ));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
