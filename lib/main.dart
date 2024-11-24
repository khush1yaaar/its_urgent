import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/core/constants/theme.dart';
import 'package:its_urgent/src/core/helpers/helper_methods.dart';
import 'package:its_urgent/src/core/routing/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:its_urgent/src/features/notification/notification_views/notification_screens/home_screen.dart';
import 'firebase_options.dart';

/// The [main] function is the entry point of the Flutter app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Lock orientation to portrait up only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init(); //init function from flutter_libphonenumber
  // await setupEmulators(); // setup Firebase Emulators for local development
  FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler); // register the background handler function
  AwesomeNotifications().initialize(
    'resource://drawable/logo', // Use 'resource://drawable/<icon_name>'
    [
      NotificationChannel(
        channelKey: 'its_urgent_notifications',
        channelName: 'Its Urgent Notifications',
        channelDescription: 'Notification channel for Its Urgent App',
        ledColor: Colors.white,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        importance: NotificationImportance.Max,
      )
    ],
  );
  Animate.restartOnHotReload = true;
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return 
    MaterialApp(
      home: HomeScreen(),
    );
    // MaterialApp.router(
    //   debugShowCheckedModeBanner: false,
    //   theme: darkTheme,
    //   darkTheme: darkTheme,
    //   themeMode: ThemeMode.dark,
    //   routerConfig: goRouter,
    // );
  }
}

const kIP = '192.168.0.38'; // for physical devices
const kLOCALHOST = '127.0.0.1'; // for emulators

// Firebase emulators Setup
Future<void> setupEmulators() async {
  await FirebaseAuth.instance.useAuthEmulator(kIP, 9099);
  FirebaseFirestore.instance.useFirestoreEmulator(kIP, 8080);
  await FirebaseStorage.instance.useStorageEmulator(kIP, 9199);
  FirebaseFunctions.instance.useFunctionsEmulator(kIP, 5001);
}

/// see ["https://firebase.google.com/docs/cloud-messaging/flutter/receive#:~:text=Handle%20background%20messages"]
// The background handler function is a top-level function and must not be inside a class.
// This function is called when the app is in the background or terminated, when a message is received.
// The function is registered in the main.dart file.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  log('Got a message whilst in the background!');
  log('Message data: ${message.data}');

  if (message.notification != null) {
    log('Message also contained a notification: ${message.notification.toString()}');
    final notificationData = {
      'title': message.notification!.title,
      'body': message.notification!.body,
    };
    await showNotification(notificationData);

    // await showNotification(message.data);
  }

  if (message.data.isNotEmpty) {
    final type = message.data['type'];
    log('Type: $type');

    // get focus status & send the focus status back to the cloud function.
    if (type ==
        notificationTypeMap[NotificationType.getFocusStatus].toString()) {
      final int focusStatus = await getFocusStatus();
      final senderUid = message.data['senderUid'];
      final receiverUid = message.data['receiverUid'];

      await sendFocusStatusToCloudFunction(
          focusStatus: focusStatus,
          senderUid: senderUid,
          receiverUid: receiverUid);
    }
  }
}
