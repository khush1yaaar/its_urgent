import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/core/constants/theme.dart';
import 'package:its_urgent/src/core/helpers/get_focus_status.dart';
import 'package:its_urgent/src/core/routing/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


const kIP = '192.168.0.131'; // for physical devices
const kLOCALHOST = '127.0.0.1'; // for emulators

// Firebase emulators Setup
Future<void> setupEmulators() async {
  await FirebaseAuth.instance.useAuthEmulator(kIP, 9099);
  FirebaseFirestore.instance.useFirestoreEmulator(kIP, 8080);
  await FirebaseStorage.instance.useStorageEmulator(kIP, 9199);
  FirebaseFunctions.instance.useFunctionsEmulator(kIP, 5001);
}

// The background handler function is a top-level function and must not be inside a class.
// This function is called when the app is in the background or terminated, when a message is received.
// The function is registered in the main.dart file.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");

  await getFocusStatus();
}


/// The [main] function is the entry point of the Flutter app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init(); //init function from flutter_libphonenumber
  await setupEmulators();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: goRouter,
    );
  }
}
