import 'package:flutter_contacts/contact.dart';
import 'package:its_urgent/src/features/notification/notification_models/app_contact.dart';
import 'package:its_urgent/src/features/notification/notification_models/non_app_contact.dart';

class DeviceContactsState {
 
  final bool permissionDenied; // permission to access device contacts, default is false
  final List<NonAppContact>? nonAppContacts; // device contacts that have not made account on the app, invite functionality
  final List<AppContact>? appContacts; // device contacts that have made account on the app

  DeviceContactsState({
   
    this.permissionDenied = false,
    this.nonAppContacts,
    this.appContacts,
  });

  // copyWith method to update the state
  DeviceContactsState copyWith({
    List<Contact>? allDeviceContacts,
    bool? permissionDenied,
    List<NonAppContact>? nonAppContacts,
    List<AppContact>? appContacts,
  }) {
    return DeviceContactsState(
      nonAppContacts: nonAppContacts ?? this.nonAppContacts,
      appContacts: appContacts ?? this.appContacts,
     
      permissionDenied: permissionDenied ?? this.permissionDenied,
    );
  }


  @override
  String toString() {
    return """
    DeviceContactsState(
     
      permissionDenied: $permissionDenied,
      nonAppContacts: $nonAppContacts,
      appContacts: $appContacts,
    )
    """;
  }
}


