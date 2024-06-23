import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/features/notification/notification_controllers/device_contacts_controller.dart';

final deviceContactsProvider = Provider<DeviceContactsController>((ref) {
  return const DeviceContactsController();
});
