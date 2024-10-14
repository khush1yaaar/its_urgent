import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceContactsController extends AsyncNotifier<List<Contact>> {
  @override
  Future<List<Contact>> build() async {
    state = AsyncLoading();

    return await fetchContacts();
  }

  Future<List<Contact>> fetchContacts() async {
    // Request permission and handle denied permission
    final permissionGranted = await _requestPermission();
    if (!permissionGranted) {
      state = AsyncError(Exception('Permission denied'), StackTrace.current);
      return [];
    }

    // Get all device contacts
    final List<Contact> deviceContacts = await _getContacts();

    // Check if device contacts are empty
    if (deviceContacts.isEmpty) {
      state = AsyncError(Exception('Device Contact Empty'),
          StackTrace.current); // Update with empty list
      return [];
    }

    // Update with fetched contacts
    return deviceContacts;
  }

  // Private methods
  Future<bool> _requestPermission() async {
    return await FlutterContacts.requestPermission(readonly: true);
  }

  Future<List<Contact>> _getContacts() async {
    return await FlutterContacts.getContacts(withProperties: true);
  }
}

final deviceContactsProvider =
    AsyncNotifierProvider<DeviceContactsController, List<Contact>>(() {
  return DeviceContactsController();
});
