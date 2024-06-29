import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/commons/common_providers/its_urgent_user_provider.dart';
import 'package:its_urgent/src/features/notification/notification_providers/cloud_function_provider.dart';
import 'package:its_urgent/src/features/notification/notification_providers/device_contacts_provider.dart';
import 'package:its_urgent/src/features/notification/notification_views/notification_widgets/contacts_permission_widget.dart';
import 'package:its_urgent/src/features/notification/notification_views/notification_widgets/empty_contacts_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsWidget extends ConsumerWidget {
  const ContactsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsProvider = ref.watch(deviceContactsProvider);

    

    // Check if permission is denied
    if (contactsProvider.permissionDenied) {
      return const ContactsPermissionWidget();
    }

    // Check if contacts are still loading
    if (
        contactsProvider.appContacts == null &&
        contactsProvider.nonAppContacts == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Check if no contacts are found on the device
    if (contactsProvider.appContacts!.isEmpty && contactsProvider.nonAppContacts!.isEmpty) {
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
                  subtitle: Text(
                    contact.phoneNumber,
                    textAlign: TextAlign.left,
                  ),
                  onTap: () async {
                    await ref.read(cloudFunctionProvider).getFocusStatus(
                      receiverUid: contact.uid,
                      senderUid: ref.read(itsUrgentUserProvider)!.uid
                    );
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
                  trailing: TextButton(
                    onPressed: () async {
                      const String message = "You are invited to It's Urgent App. Check the app from https://github.com/0xharkirat/its_urgent";
                      final smsURI = Uri.parse('sms:${contact.phoneNumber}?body=$message');
                      await launchUrl(smsURI);
                    },
                    child: const Text("Invite"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
