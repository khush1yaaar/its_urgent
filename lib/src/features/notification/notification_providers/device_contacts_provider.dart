import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/features/notification/notification_controllers/device_contacts_controller.dart';
import 'package:its_urgent/src/features/notification/notification_models/device_contact_state.dart';

final deviceContactsProvider = NotifierProvider<DeviceContactsController, DeviceContactsState>(() {
  return  DeviceContactsController();
});
