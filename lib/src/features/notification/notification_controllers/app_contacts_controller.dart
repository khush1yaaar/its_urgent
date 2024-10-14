import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/core/controllers/cloud_firestore_controller.dart';
import 'package:its_urgent/src/core/helpers/format_phone_number.dart';
import 'package:its_urgent/src/core/models/user_ref.dart';
import 'package:its_urgent/src/features/notification/notification_controllers/device_contacts_controller.dart';
import 'package:its_urgent/src/features/notification/notification_models/app_contact.dart';

class AppContactsNotifier extends AsyncNotifier<List<AppContact>> {
  @override
  Future<List<AppContact>> build() async {
    final deviceContacts = await ref.read(deviceContactsProvider.future);

    log('Device contacts: $deviceContacts');

    // Fetch userRefs from Firestore
    final List<UserRef> firestoreUserRefs =
        await ref.read(cloudFirestoreController).fetchUsersRefs();



    // final appContactsUserRefs = <UserRef>[];

    // for (final contact in deviceContacts) {
    //   if (contact.phones.isNotEmpty) {
    //     final formattedNumber =
    //         contact.phones.first.number.formattedPhoneNumber;

    //     // Check if the contact matches any user in Firestore
    //     final matchingUser = firestoreUserRefs.firstWhere(
    //       (user) => user.phoneNumber == formattedNumber,
    //     );

    //     if (matchingUser != null) {
    //       appContactsUserRefs.add(matchingUser);
    //     }
    //   }
    // }
    // final List<AppContact> appContacts = await ref
    //     .read(cloudFirestoreController)
    //     .fetchUsersFromFirestore(appContactsUserRefs);

    return [];
  }
}

final appContactsProvider =
    AsyncNotifierProvider<AppContactsNotifier, List<AppContact>>(() {
  return AppContactsNotifier();
});
