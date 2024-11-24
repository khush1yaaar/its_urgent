import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:its_urgent/src/features/auth/auth_controllers/phone_auth_controller.dart';
import 'package:its_urgent/src/features/notification/notification_controllers/combined_contacts_controller.dart';
import 'package:its_urgent/src/features/notification/notification_controllers/notification_controller.dart';
import 'package:its_urgent/src/features/notification/notification_views/notification_widgets/app_contacts_widget.dart';
import 'package:its_urgent/src/features/notification/notification_views/notification_widgets/edit_profile_dialog.dart';
import 'package:its_urgent/src/features/notification/notification_views/notification_widgets/non_app_contacts_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future<void> _init() async {
    await ref.read(notificationInstanceProvider).setupToken();

    ref
        .read(notificationInstanceProvider)
        .notificationForegroundListener(context);
  }

  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(phoneAuthController).signOut();
              Navigator.of(context).pop(); // Close the dialog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded border
              ),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: const Text("It's Urgent"),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'App Contacts',
              ),
              Tab(text: 'Non-App Contacts'),
            ],
          ),
          actions: [
            IconButton(
              tooltip: "Refresh Contacts",
              onPressed: () async {
                await ref.read(combinedContactsController.notifier).refresh();
              },
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              tooltip: "Edit Profile",
              onPressed: () async {
                showDialog(
                    context: context, builder: (_) => EditProfileDialog());
              },
              icon: const Icon(Icons.person),
            ),
            IconButton(
              tooltip: "Logout",
              onPressed: () async {
                await _showLogoutDialog(context);
              },
              icon: Icon(Icons.logout, color: Colors.red[300]),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            AppContactsWidget(),
            NonAppContactsWidget(),
          ],
        ),
      ),
    );
  }
}
