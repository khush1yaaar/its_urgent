

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

  Future<CombinedContacts> fetchAndFilter() async {
    final deviceContacts = await ref.read(deviceContactsProvider.future);
    
    // Fetch userRefs from Firestore
    final List<UserRef> firestoreUserRefs =
        await ref.read(cloudFirestoreController).fetchUsersRefs();
    
    // Filter app and non-app contacts
    final Map<String, dynamic> contactResults =
        _filterContacts(deviceContacts, firestoreUserRefs);
    
    final List<AppContact> appContacts = await ref
        .read(cloudFirestoreController)
        .fetchUsersFromFirestore(contactResults['appContactsUserRefs']);
    
    
       
    
    return CombinedContacts(
      appContacts: appContacts,
      nonAppContacts: contactResults['nonAppContacts'],
    );
  }
}

final combinedContactsController =
    AsyncNotifierProvider<CombinedContactsController, CombinedContacts>(() {
  return CombinedContactsController();
});


// Filter app contacts and non-app contacts
  Map<String, dynamic> _filterContacts(
      List<Contact> deviceContacts, List<UserRef> firestoreUserRefs) {
    final List<UserRef> appContactsUserRefs = [];
    final List<NonAppContact> nonAppContacts = [];

   for (final contact in deviceContacts) {
      if (contact.phones.isNotEmpty) {
        final formattedNumber =
            contact.phones.first.number.formattedPhoneNumber;

        // Check if the contact matches any user in Firestore
        // Check if there are any matching user refs for the formatted number
        final matchingUserRefs = firestoreUserRefs
            .where(
              (userRef) => userRef.phoneNumber == formattedNumber,
            )
            .toList();

        if (matchingUserRefs.isNotEmpty) {
          appContactsUserRefs.add(matchingUserRefs
              .first); // Found in Firestore - it's an app contact
        } else {
          nonAppContacts.add(NonAppContact.fromContact(
              contact)); // Not found in Firestore - it's a non-app contact
        }
      }
    }

    return {
      'appContactsUserRefs': appContactsUserRefs,
      'nonAppContacts': nonAppContacts,
    };
  }