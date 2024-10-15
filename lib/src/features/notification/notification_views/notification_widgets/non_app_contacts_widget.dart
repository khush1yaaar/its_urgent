

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/features/notification/notification_controllers/combined_contacts_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class NonAppContactsWidget extends ConsumerWidget {
  const NonAppContactsWidget({super.key});

  String getInitials(String fullName) {
    final nameParts = fullName.trim().split(' ');
    final firstInitial =
        nameParts.isNotEmpty ? nameParts[0][0].toUpperCase() : '';
    final secondInitial =
        nameParts.length > 1 ? nameParts[1][0].toUpperCase() : '';
    return '$firstInitial$secondInitial';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsState = ref.watch(combinedContactsController);

   

    return Scaffold(
      body: contactsState.when(
        data: (combinedContacts) {
          final contacts = combinedContacts.nonAppContacts;
          if (contacts.isEmpty) {
            return const Center(
              child: Text('No contacts found.'),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(combinedContactsController.notifier)
                  .refresh();
            },
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      contact.name.isNotEmpty ? getInitials(contact.name) : '?',
                    ),
                  ),
                  title: Text(contact.name),
                  trailing: TextButton.icon(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: () async {
                      const String message =
                          "You are invited to It's Urgent App. Check the app from https://github.com/0xharkirat/its_urgent";
                      final smsURI =
                          Uri.parse('sms:${contact.phoneNumber}?body=$message');
                      await launchUrl(smsURI);
                    },
                    label: const Text("Invite"),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) {
          if (error.toString().contains('Permission denied')) {
            return const Center(
              child: Text(
                  'Permission denied. Please enable contacts permission.',
                  textAlign: TextAlign.center),
            );
          }
          if (error.toString().contains('Device contacts are empty')) {
            return const Center(
              child: Text(
                'There are no contacts on your device. Please add some contacts.',
                textAlign: TextAlign.center,
              ),
            );
          }
          return Center(
            child: Text(
              'An error occurred while fetching contacts: $error',
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
