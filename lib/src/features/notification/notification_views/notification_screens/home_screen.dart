import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/src/core/controllers/cloud_firestore_controller.dart';
import 'package:its_urgent/src/core/controllers/firebase_auth_controller.dart';
import 'package:its_urgent/src/core/controllers/its_urgent_user_controller.dart';
import 'package:its_urgent/src/core/routing/app_router.dart';
import 'package:its_urgent/src/features/auth/auth_controllers/phone_auth_controller.dart';
import 'package:its_urgent/src/features/notification/notification_providers/device_contacts_provider.dart';
import 'package:its_urgent/src/features/notification/notification_providers/notification_provider.dart';
import 'package:its_urgent/src/features/notification/notification_views/notification_widgets/contacts_widget.dart';
import 'package:its_urgent/src/features/notification/notification_views/notification_widgets/permission_button_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  Future<void> _init() async {
    await ref.read(notificationInstanceProvider).setupToken();

    // await ref.read(deviceContactsProvider.notifier).fetchContacts();\

    ref
        .read(notificationInstanceProvider)
        .notificationForegroundListener(context);
    // await setupInteractedMessage();

    // listenActionStream(){
    //     AwesomeNotifications().actionStream.listen((receivedAction) {
    //       var payload = receivedAction.payload;

    //       if(receivedAction.channelKey == 'normal_channel'){
    //         //do something here
    //       }
    //     });
    //   }
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
              await ref.read(phoneAuthController).signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: DeviceContactsWidget(),
      ),
    );
  }
}
