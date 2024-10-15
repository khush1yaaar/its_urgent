import 'dart:developer';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/core/controllers/cloud_firestore_controller.dart';
import 'package:its_urgent/src/core/helpers/format_phone_number.dart';
import 'package:its_urgent/src/core/models/user_ref.dart';
import 'package:its_urgent/src/features/notification/notification_controllers/device_contacts_controller.dart';
import 'package:its_urgent/src/features/notification/notification_models/app_contact.dart';
import 'package:its_urgent/src/features/notification/notification_models/combined_contacts.dart';
import 'package:its_urgent/src/features/notification/notification_models/non_app_contact.dart';

class CombinedContactsController extends AsyncNotifier<CombinedContacts> {
  @override
  Future<CombinedContacts> build() async {
    return await fetchAndFilter();
  }

  /// Refresh the contacts and update the state.
  Future<void> refresh() async {
    state = const AsyncLoading(); // Show loading indicator during refresh

    // Refresh the device contacts
    await ref.read(deviceContactsProvider.notifier).refreshContacts();

    // Re-fetch and update the combined contacts
    state = await AsyncValue.guard(() => fetchAndFilter());
  }

  /// Fetch and filter contacts from both the device and Firestore.
  Future<CombinedContacts> fetchAndFilter() async {
    try {
      final deviceContacts = await ref.read(deviceContactsProvider.future);
      log("Device Contacts: $deviceContacts");

      // Fetch userRefs from Firestore
      final List<UserRef> firestoreUserRefs =
          await ref.read(cloudFirestoreController).fetchUsersRefs();
      log("Firestore UserRefs: $firestoreUserRefs");

      // Filter app and non-app contacts
      final Map<String, dynamic> contactResults =
          _filterContacts(deviceContacts, firestoreUserRefs);

      // Fetch app contacts from Firestore
      final List<AppContact> appContacts = await ref
          .read(cloudFirestoreController)
          .fetchUsersFromFirestore(contactResults['appContactsUserRefs']);

      // Return the combined contacts
      return CombinedContacts(
        appContacts: appContacts,
        nonAppContacts: contactResults['nonAppContacts'],
      );
    } catch (e, stackTrace) {
      log('Error fetching and filtering contacts: $e');
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  /// Filter the contacts into app and non-app contacts.
  Map<String, dynamic> _filterContacts(
      List<Contact> deviceContacts, List<UserRef> firestoreUserRefs) {
    final List<UserRef> appContactsUserRefs = [];
    final List<NonAppContact> nonAppContacts = [];

    for (final contact in deviceContacts) {
      if (contact.phones.isNotEmpty) {
        final formattedNumber = contact.phones.first.number.formattedPhoneNumber;

        // Check if the contact matches any user in Firestore
        final matchingUserRefs = firestoreUserRefs
            .where((userRef) => userRef.phoneNumber == formattedNumber)
            .toList();

        if (matchingUserRefs.isNotEmpty) {
          log("Matching UserRefs: $matchingUserRefs");
          appContactsUserRefs.add(matchingUserRefs.first);
        } else {
          nonAppContacts.add(NonAppContact.fromContact(contact));
        }
      }
    }

    return {
      'appContactsUserRefs': appContactsUserRefs,
      'nonAppContacts': nonAppContacts,
    };
  }
}

// Create a provider for the CombinedContactsController
final combinedContactsController =
    AsyncNotifierProvider<CombinedContactsController, CombinedContacts>(() {
  return CombinedContactsController();
});
