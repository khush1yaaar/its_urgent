import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/commons/common_providers/cloud_firestore_provider.dart';
import 'package:its_urgent/src/commons/common_providers/firebase_auth_provider.dart';
import 'package:its_urgent/src/commons/common_providers/its_urgent_user_provider.dart';
import 'package:its_urgent/src/features/notification/notification_providers/device_contacts_provider.dart';
import 'package:its_urgent/src/features/notification/notification_providers/notification_provider.dart';
import 'package:its_urgent/src/features/notification/notification_views/notification_widgets/contacts_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool permissionGranted = false;

  Future<void> _init() async {
    final user = ref.read(itsUrgentUserProvider);
    if (user == null) {
      final uid = ref.read(firebaseAuthProvider).currentUser!.uid;
      await ref.read(cloudFirestoreProvider).checkForExistingUserData(uid);
    }

    await ref.read(notificationInstanceProvider).setupToken();
    await ref.read(deviceContactsProvider.notifier).fetchContacts();
    ref.read(notificationInstanceProvider).notificationForegroundListener();
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
              await ref.read(deviceContactsProvider.notifier).fetchContacts();
            },
            icon: const Icon(Icons.refresh),
          ),
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
