
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/commons/common_models/common_class_models/its_urgent_user.dart';
import 'package:its_urgent/src/commons/common_models/common_class_models/user_ref.dart';
import 'package:its_urgent/src/commons/common_providers/cloud_firestore_provider.dart';
import 'package:its_urgent/src/core/helpers/format_phone_number.dart';
import 'package:its_urgent/src/features/notification/notification_models/app_contact.dart';
import 'package:its_urgent/src/features/notification/notification_models/device_contact_state.dart';
import 'package:its_urgent/src/features/notification/notification_models/non_app_contact.dart';

class DeviceContactsController extends Notifier<DeviceContactsState> {
  @override
  DeviceContactsState build() {
    return DeviceContactsState();
  }

  Future<void> fetchContacts() async {
    final permission = await _requestPermission();
    if (!permission) {
      state = state.copyWith(permissionDenied: true);
      return;
    }

    /// get all device contacts
    final List<Contact> deviceContacts = await _getContacts();
    state = state.copyWith(allDeviceContacts: deviceContacts);

    for (final contact in deviceContacts) {
      print("Contact: ${contact.displayName}, phones: ${contact.phones.first.number.formattedPhoneNumber}");
      
    }

    /// fetch userRefs from cloud_firestore
    final List<UserRef> firestoreUserRefs =
        await ref.read(cloudFirestoreProvider).fetchUsersRefs();


    /// ------------------------------
    /// For [AppContact]
    /// filter contacts that have made account on the app
    final List<UserRef> appContactsUserRefs = firestoreUserRefs
        .where((user) => deviceContacts.any((contact) =>
            contact.phones.isNotEmpty &&
            user.phoneNumber ==
                contact.phones.first.number.formattedPhoneNumber))
        .toList();

    final List<AppContact> appContactsTypeItsUrgentUsers = await ref
        .read(cloudFirestoreProvider)
        .fetchUsersFromFirestore(appContactsUserRefs);

    state = state.copyWith(appContacts: appContactsTypeItsUrgentUsers);


    /// ------------------------------
    /// For [NonAppContact]
    /// filter contacts that have not made account on the app
    final List<Contact> nonAppContactsTypeContacts =
        deviceContacts.where((contact) {
      return contact.phones.isNotEmpty &&
          !firestoreUserRefs.any((user) =>
              user.phoneNumber ==
              contact.phones.first.number.formattedPhoneNumber);
    }).toList();

    /// convert [Contact] to [NonAppContact]
    final List<NonAppContact> nonAppContactsTypeNonAppContacts =
        nonAppContactsTypeContacts.map((contact) {
      return NonAppContact.fromContact(contact);
    }).toList();

    // update the state
    state = state.copyWith(nonAppContacts: nonAppContactsTypeNonAppContacts);
   
    
  }

  /// private methods - only accessible within this controller
  Future<bool> _requestPermission() async {
    return await FlutterContacts.requestPermission(readonly: true);
  }

  Future<List<Contact>> _getContacts() async {
    return await FlutterContacts.getContacts(withProperties: true);
  }
}


