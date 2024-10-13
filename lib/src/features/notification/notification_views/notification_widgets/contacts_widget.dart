import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/features/notification/notification_providers/device_contacts_provider.dart';

class DeviceContactsWidget extends ConsumerWidget {
  const DeviceContactsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsState = ref.watch(deviceContactsProvider);

    return Scaffold(
      body: contactsState.when(
        data: (contacts) {
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
                    contact.displayName.isNotEmpty
                        ? contact.displayName[0].toUpperCase()
                        : '?',
                  ),
                ),
                title: Text(contact.displayName),
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
          return Center(
            child: Text('An error occurred while fetching contacts: $error'),
          );
        },
      ),
    );
  }
}
