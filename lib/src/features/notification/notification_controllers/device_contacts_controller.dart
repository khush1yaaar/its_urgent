import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceContactsController extends AsyncNotifier<List<Contact>> {
  @override
  Future<List<Contact>> build() async {
    return await fetchContacts(); // No need to set `AsyncLoading` here, it's done automatically.
  }

  Future<void> refreshContacts() async {
    state = const AsyncLoading(); // Set loading state explicitly during refresh
    state = await AsyncValue.guard(() => fetchContacts());
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

    if (deviceContacts.isEmpty) {
      state = AsyncError(Exception('Device contacts are empty'), StackTrace.current);
      return [];
    }

    return deviceContacts; // Successfully fetched contacts
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
