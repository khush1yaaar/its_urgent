import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/src/commons/common_providers/cloud_firestore_provider.dart';
import 'package:its_urgent/src/commons/common_providers/firebase_auth_provider.dart';
import 'package:its_urgent/src/commons/common_providers/its_urgent_user_provider.dart';
import 'package:its_urgent/src/core/routing/app_router.dart';
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
  bool _notificationPermission = false;

  bool _isLoading = false;

  Future<void> _init() async {
    final user = ref.read(itsUrgentUserProvider);
    if (user == null) {
      final uid = ref.read(firebaseAuthProvider).currentUser!.uid;
      await ref.read(cloudFirestoreProvider).checkForExistingUserData(uid);
    }

    await ref.read(notificationInstanceProvider).setupToken();

    _notificationPermission = await ref
        .read(notificationInstanceProvider)
        .requestNotificationPermission();
    setState(() {});
    // await ref.read(deviceContactsProvider.notifier).fetchContacts();\

    ref.read(notificationInstanceProvider).notificationForegroundListener(context);
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
    WidgetsBinding.instance!.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _isLoading = true;
      });

      print("App Resumed");
      _notificationPermission = await ref
          .read(notificationInstanceProvider)
          .requestNotificationPermission();

      setState(() {
        _isLoading = false;
      });
    }
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
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _notificationPermission
                ? const ContactsWidget()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PermissionButtonWidget(
                        title: "Notification Permissions Denied",
                        subtitle:
                            "Tap here to go to device settings to grant notification permissions",
                        iconData: Icons.notifications_active,
                        onPressed: () {
                          AppSettings.openAppSettings(
                              type: AppSettingsType.notification);
                        }),
                  ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            context.goNamed(AppRoutes.challengeScreen.name, queryParameters: {
              'name': 'John Doe',
            });
          },
          child: const Icon(Icons.input),
        ));
  }
}
