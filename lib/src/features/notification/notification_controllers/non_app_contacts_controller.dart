import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/core/controllers/cloud_firestore_controller.dart';
import 'package:its_urgent/src/core/models/user_ref.dart';
import 'package:its_urgent/src/core/helpers/format_phone_number.dart';
import 'package:its_urgent/src/features/notification/notification_models/app_contact.dart';
import 'package:its_urgent/src/features/notification/notification_models/device_contact_state.dart';
import 'package:its_urgent/src/features/notification/notification_models/non_app_contact.dart';

class NonAppContactsController extends AsyncNotifier<List<NonAppContact>> {
  @override
  Future<List<NonAppContact>> build() async {
    state = AsyncLoading();

    return await fetchContacts();
  }

  Future<List<NonAppContact>> fetchContacts() async {
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
      state = const AsyncData([]); // Update with empty list
      return [];
    }

    final nonAppContacts = deviceContacts
        .where((contact) => contact.phones.isNotEmpty)
        .map((contact) => NonAppContact.fromContact(contact))
        .toList();

    // Update with fetched contacts
    return nonAppContacts;

    // // Fetch userRefs from Firestore
    // final List<UserRef> firestoreUserRefs =
    //     await ref.read(cloudFirestoreController).fetchUsersRefs();

    // // Filter app and non-app contacts
    // final Map<String, dynamic> contactResults =
    //     _filterContacts(deviceContacts, firestoreUserRefs);

    // final List<AppContact> appContacts = await ref
    //     .read(cloudFirestoreController)
    //     .fetchUsersFromFirestore(contactResults['appContactsUserRefs']);

    // // Update state with the results
    // state = DeviceContactsState(
    //   nonAppContacts: contactResults['nonAppContacts'],
    //   appContacts: appContacts,
    //   permissionDenied: false,
    // );
  }

  // Private methods
  Future<bool> _requestPermission() async {
    return await FlutterContacts.requestPermission(readonly: true);
  }

  Future<List<Contact>> _getContacts() async {
    return await FlutterContacts.getContacts(withProperties: true);
  }

  // Filter app contacts and non-app contacts
  // Map<String, dynamic> _filterContacts(
  //     List<Contact> deviceContacts, List<UserRef> firestoreUserRefs) {
  //   final List<UserRef> appContactsUserRefs = [];
  //   final List<NonAppContact> nonAppContacts = [];

  //   for (final contact in deviceContacts) {
  //     if (contact.phones.isNotEmpty) {
  //       final formattedNumber = contact.phones.first.number.formattedPhoneNumber;

  //       // Check if the contact matches any user in Firestore
  //       final matchingUser = firestoreUserRefs.firstWhere(
  //         (user) => user.phoneNumber == formattedNumber,

  //       );

  //       if (matchingUser != null) {
  //         appContactsUserRefs.add(matchingUser);
  //       } else {
  //         nonAppContacts.add(NonAppContact.fromContact(contact));
  //       }
  //     }
  //   }

  //   return {
  //     'appContactsUserRefs': appContactsUserRefs,
  //     'nonAppContacts': nonAppContacts,
  //   };
  // }
}


final nonAppContactsProvider = AsyncNotifierProvider<NonAppContactsController, List<NonAppContact>>(() {
  return  NonAppContactsController
  ();
});
