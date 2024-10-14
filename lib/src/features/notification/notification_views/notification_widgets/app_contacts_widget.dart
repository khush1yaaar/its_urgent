import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/features/notification/notification_controllers/combined_contacts_controller.dart';



class AppContactsWidget extends ConsumerWidget {
  const AppContactsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsState = ref.watch(combinedContactsController);

    return Scaffold(
     
        body: contactsState.when(
          data: (combinedContacts) {
            final contacts = combinedContacts.appContacts;
            if (contacts.isEmpty) {
              return const Center(
                child: Text('No contacts found.'),
              );
            }
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      contact.name.isNotEmpty
                          ? contact.name[0].toUpperCase()
                          : '?',
                    ),
                  ),
                  title: Text(contact.name),
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) {
            if (error.toString().contains('Permission denied')) {
              return const Center(
                child:
                    Text('Permission denied. Please enable contacts permission.'),
              );
            }
            if (error.toString().contains('Device Contact Empty')) {
              return const Center(
                child: Text('There are no contacts on your device. Please add some contacts.'),
              );
            }
            return Center(
              child: Text('An error occurred while fetching contacts: $error'),
            );
          },
        ),
        );
  }
}
