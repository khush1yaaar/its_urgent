import 'package:flutter_contacts/contact.dart';

class DeviceContactsState {
  final List<Contact>? contacts;
  final bool permissionDenied;

  DeviceContactsState({this.contacts, this.permissionDenied = false});

  
}
