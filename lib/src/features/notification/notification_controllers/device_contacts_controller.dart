import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/commons/common_providers/cloud_firestore_provider.dart';
import 'package:its_urgent/src/features/notification/notification_models/device_contact_state.dart';

class DeviceContactsController extends Notifier<DeviceContactsState> {
  @override
  DeviceContactsState build() {
    return DeviceContactsState();
  }

  Future<void> fetchContacts() async {
    final permission = await _requestPermission();
    if (!permission) {
      state = DeviceContactsState(permissionDenied: true);
      return;
    }
    await ref.read(cloudFirestoreProvider).fetchUsersRefs();
    final List<Contact> contacts = await _getContacts();
    state = DeviceContactsState(contacts: contacts);
  }

  Future<bool> _requestPermission() async {
    return await FlutterContacts.requestPermission(readonly: true);
  }

  Future<List<Contact>> _getContacts() async {
    return await FlutterContacts.getContacts(withProperties: true);
  }
}
