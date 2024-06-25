import 'package:flutter_contacts/contact.dart';
import 'package:its_urgent/src/commons/common_models/common_class_models/its_urgent_user.dart';
import 'package:its_urgent/src/features/notification/notification_models/non_app_contact.dart';

class DeviceContactsState {
  final List<Contact>? allDeviceContacts; // all device contacts fetched from the device
  final bool permissionDenied; // permission to access device contacts, default is false
  final List<NonAppContact>? nonAppContacts; // device contacts that have not made account on the app, invite functionality
  final List<AppContact>? appContacts; // device contacts that have made account on the app

  DeviceContactsState({
    this.allDeviceContacts,
    this.permissionDenied = false,
    this.nonAppContacts,
    this.appContacts,
  });

  // copyWith method to update the state
  DeviceContactsState copyWith({
    List<Contact>? allDeviceContacts,
    bool? permissionDenied,
    List<NonAppContact>? nonAppContacts,
    List<ItsUrgentUser>? appContacts,
  }) {
    return DeviceContactsState(
      nonAppContacts: nonAppContacts ?? this.nonAppContacts,
      appContacts: appContacts ?? this.appContacts,
      allDeviceContacts: allDeviceContacts ?? this.allDeviceContacts,
      permissionDenied: permissionDenied ?? this.permissionDenied,
    );
  }


  @override
  String toString() {
    return """
    DeviceContactsState(
      allDeviceContacts: $allDeviceContacts,
      permissionDenied: $permissionDenied,
      nonAppContacts: $nonAppContacts,
      appContacts: $appContacts,
    )
    """;
  }
}


