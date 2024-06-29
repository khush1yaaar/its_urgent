import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/commons/common_models/common_class_models/user_ref.dart';
import 'package:its_urgent/src/commons/common_providers/cloud_firestore_provider.dart';
import 'package:its_urgent/src/core/helpers/format_phone_number.dart';
import 'package:its_urgent/src/features/notification/notification_models/app_contact.dart';
import 'package:its_urgent/src/features/notification/notification_models/device_contact_state.dart';
import 'package:its_urgent/src/features/notification/notification_models/non_app_contact.dart';

class DeviceContactsController extends Notifier<DeviceContactsState> {
  @override
  DeviceContactsState build() {
    fetchContacts();
    return DeviceContactsState();
  }

  Future<void> fetchContacts() async {
    final permission = await _requestPermission();
    if (!permission) {
      state = state.copyWith(permissionDenied: true);
      return;
    }

    // Get all device contacts
    final List<Contact> deviceContacts = await _getContacts();

    // Fetch userRefs from cloud_firestore
    final List<UserRef> firestoreUserRefs =
        await ref.read(cloudFirestoreProvider).fetchUsersRefs();

    // Use compute for filtering app contacts
    final appContactsResult = await compute(_filterAppContacts, {
      'firestoreUserRefs': firestoreUserRefs,
      'deviceContacts': deviceContacts,
    });

    final List<UserRef> appContactsUserRefs =
        appContactsResult['appContactsUserRefs'];
    final List<Contact> remainingDeviceContacts =
        appContactsResult['remainingDeviceContacts'];

    // Fetch app contacts from firestore
    final List<AppContact> appContacts = await ref
        .read(cloudFirestoreProvider)
        .fetchUsersFromFirestore(appContactsUserRefs);

    // Use compute for converting remaining contacts to non-app contacts
    final List<NonAppContact> nonAppContacts =
        await compute(_filterNonAppContacts, remainingDeviceContacts);

    // Update the state
    state = DeviceContactsState(
      nonAppContacts: nonAppContacts,
      appContacts: appContacts,
      permissionDenied: false,
    );
  }

  // Private methods
  Future<bool> _requestPermission() async {
    return await FlutterContacts.requestPermission(readonly: true);
  }

  Future<List<Contact>> _getContacts() async {
    return await FlutterContacts.getContacts(withProperties: true);
  }
}

// Helper functions for compute
Map<String, dynamic> _filterAppContacts(Map<String, dynamic> data) {
  final List<UserRef> firestoreUserRefs = data['firestoreUserRefs'];
  final List<Contact> deviceContacts =
      List<Contact>.from(data['deviceContacts']);

  final List<UserRef> appContactsUserRefs = firestoreUserRefs.where((user) {
    final contactIndex = deviceContacts.indexWhere((contact) =>
        contact.phones.isNotEmpty &&
        user.phoneNumber == contact.phones.first.number.formattedPhoneNumber);
    if (contactIndex != -1) {
      deviceContacts.removeAt(contactIndex);
      return true;
    }
    return false;
  }).toList();

  return {
    'appContactsUserRefs': appContactsUserRefs,
    'remainingDeviceContacts': deviceContacts,
  };
}

List<NonAppContact> _filterNonAppContacts(List<Contact> deviceContacts) {
  return deviceContacts
      .where((contact) => contact.phones.isNotEmpty)
      .map((contact) => NonAppContact.fromContact(contact))
      .toList();
}
