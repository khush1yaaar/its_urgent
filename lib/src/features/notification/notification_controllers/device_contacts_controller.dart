import 'package:flutter_contacts/flutter_contacts.dart';

class DeviceContactsController {
  const DeviceContactsController();

  Future<bool> requestPermission() async {
    return await FlutterContacts.requestPermission();
  }

  Future<List<Contact>> getContacts() async {
    return await FlutterContacts.getContacts();
  }
}

