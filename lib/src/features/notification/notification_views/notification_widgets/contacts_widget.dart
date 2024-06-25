import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/features/notification/notification_providers/device_contacts_provider.dart';
import 'package:its_urgent/src/features/notification/notification_views/notification_widgets/contacts_permission_widget.dart';
import 'package:its_urgent/src/features/notification/notification_views/notification_widgets/empty_contacts_widget.dart';

class ContactsWidget extends ConsumerWidget {
  const ContactsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsProvider = ref.watch(deviceContactsProvider);
    if (contactsProvider.permissionDenied) {
      return const ContactsPermissionWidget();
    }
    if (contactsProvider.contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (contactsProvider.contacts!.isEmpty) {
      return const EmptyContactsWidget();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
          Expanded(
            child: ListView.builder(
              itemCount: contactsProvider.contacts!.length,
              itemBuilder: (context, i) {
                final contact = contactsProvider.contacts![i];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer)),
                  ),
                  child: TextButton(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        contact.displayName,
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    onPressed: () async {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (_) => ContactPage(contact),
                      // ));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
