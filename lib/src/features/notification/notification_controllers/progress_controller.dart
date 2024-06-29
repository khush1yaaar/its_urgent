import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/features/notification/notification_providers/device_contacts_provider.dart';

class ProgressController extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    state = const AsyncValue.loading();
    await ref.read(deviceContactsProvider.notifier).fetchContacts();
    return true;
  }
}
