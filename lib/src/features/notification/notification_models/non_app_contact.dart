import 'package:flutter_contacts/flutter_contacts.dart';

class NonAppContact {
  final String name;
  final String phoneNumber;
  final String imagePath = 'assets/profile.png';

  NonAppContact({required this.name, required this.phoneNumber});

  
  // factory method to create NonAppContact from Contact - from flutter_contacts package
  factory NonAppContact.fromContact(Contact contact) {
    return NonAppContact(
      name: contact.displayName,
      phoneNumber: contact.phones.first.number,
    );
  }
}