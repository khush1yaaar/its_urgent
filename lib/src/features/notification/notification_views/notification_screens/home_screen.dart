import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/commons/common_providers/firebase_auth_provider.dart';
import 'package:its_urgent/src/features/notification/notification_providers/device_contacts_provider.dart';
import 'package:its_urgent/src/features/notification/notification_providers/notification_provider.dart';
import 'package:its_urgent/src/features/notification/notification_views/notification_widgets/contacts_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  bool permissionGranted = false;

  Future<void> _init() async {
    await ref.read(notificationInstanceProvider).setupToken();
    await ref.read(deviceContactsProvider.notifier).fetchContacts();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  

   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("It's Urgent"),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(phoneAuthProvider).signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const ContactsWidget(),
    );
  }
}
