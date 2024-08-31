import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/src/core/controllers/cloud_firestore_controller.dart';
import 'package:its_urgent/src/core/controllers/permissions_controller.dart';
import 'package:its_urgent/src/core/views/screens/permissions_screen.dart';
import 'package:its_urgent/src/core/helpers/go_router_refresh_stream.dart';
import 'package:its_urgent/src/core/controllers/firebase_auth_controller.dart';
import 'package:its_urgent/src/features/notification/notification_views/notification_screens/challenge_screen.dart';
import 'package:its_urgent/src/features/splash/splash_providers/splash_screen_provider.dart';
import 'package:its_urgent/src/features/auth/auth_views/auth_screens/auth_screen.dart';
import 'package:its_urgent/src/core/views/screens/error_screen.dart';
import 'package:its_urgent/src/features/auth/auth_views/auth_screens/country_selector_screen.dart';
import 'package:its_urgent/src/features/auth/auth_views/auth_screens/edit_profile_screen.dart';
import 'package:its_urgent/src/features/notification/notification_views/notification_screens/home_screen.dart';
import 'package:its_urgent/src/features/splash/splash_views/screens/splash_screen.dart';
import 'package:its_urgent/src/features/auth/auth_views/auth_screens/sms_screen.dart';

// const path parameters name
enum PathParams {
  phoneNumber,
  verificationId,
}

// enum for named routes
enum AppRoutes {
  splashScreen,
  permissionsScreen,
  homeScreen,
  authScreen,
  errorScreen,
  // verifyEmailScreen,
  countrySelectorScreen,
  smsCodeScreen,
  editProfileScreen,
  challengeScreen,
}

// Const route paths
const authScreenPath = '/authScreen';
const homeScreenPath = '/homeScreen';
const splashScreenPath = '/splashScreen';
const errorScreenPath = '/errorScreen';
// const verifyEmailScreenPath = '/verifyEmailScreen';
const countrySelectorScreenPath = '/countrySelectorScreen';
const editProfileScreenPath = '/editProfileScreen';
final smsCodeScreenPath =
    'smsCodeScreen/:${PathParams.phoneNumber.name}/:${PathParams.verificationId.name}';
const challengeScreenPath = '/challengeScreen';
const permissionsScreenPath = '/permissionsScreen';

final rootNavigatorKey = GlobalKey<NavigatorState>();

int appRedirectCount = 0;
// go router provider
final goRouterProvider = Provider<GoRouter>((ref) {
  // Get the instance of FirebaseAuth
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final splashScreenBoolean = ref.watch(splashScreenBooleanProvider);
  // final appPermission = ref.watch(permissionsControllerProvider);

  // final permissionsBool = ref.watch(permissionBoolController);

  return GoRouter(
    initialLocation: splashScreenPath,
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      // if (kDebugMode) {
      //   debugPrint(
      //       "\n<----- calling redirect function for the  ${++appRedirectCount} ------>");
      //   debugPrint("current route BEFORE logic is: ${state.matchedLocation}");
      // }

      final isLoggedIn = firebaseAuth.currentUser != null;
      final isSplashRoute = state.matchedLocation == splashScreenPath;
      final isHomeScreenRoute = state.matchedLocation == homeScreenPath;
      final isAuthScreenRoute =
          state.matchedLocation.startsWith(authScreenPath);

      // if (permissionsBool.isLoading) {
      //   log("permissionsBool.isLoading");
      //   log("going to splashScreenPath");
      //   return splashScreenPath;
      // }

      // if (permissionsBool.value == false) {
      //   log("permissionsBool.value == false");
      //   log("going to permissionsScreenPath");
      //   return permissionsScreenPath;
      // } 

      // Check if permissions are loaded and determine if any permission is required
      // final isContactPermissionGranted =
      //     appPermission.contactPermissions.asData?.value ?? false;
      // final isNotificationPermissionGranted =
      //     appPermission.notificationPermissions.asData?.value ?? false;
      // final isDndAccessPermissionGranted =
      //     appPermission.dndInterruptionPermissions.asData?.value ?? false;

      // print("Is logged IN; $isLoggedIn");

      if (!isLoggedIn) {
        // debugPrint("We have entered now in not isLoggedIn.....");
        // debugPrint("current route AFTER logic is: ${state.matchedLocation}");
        if (splashScreenBoolean && isSplashRoute && splashScreenBoolean) {
          return permissionsScreenPath;
        }
        if ((splashScreenBoolean && isSplashRoute) || isHomeScreenRoute) {
          if (state.matchedLocation != authScreenPath) {
            // debugPrint("We have entered now in authscreepath");
            // debugPrint(
            //     "current route AFTER logic is: ${state.matchedLocation}");
            return authScreenPath;
          }
        } else if (splashScreenBoolean && isAuthScreenRoute) {
          // debugPrint(
          //     "We have entered now in state.matched location - verification screen");
          // debugPrint("current route AFTER logic is: ${state.matchedLocation}");
          return state.matchedLocation;
        } else if (!splashScreenBoolean) {
          if (state.matchedLocation != splashScreenPath) {
            // debugPrint("We have entered now in splashscreen path");
            // debugPrint(
            //     "current route AFTER logic is: ${state.matchedLocation}");
            return splashScreenPath;
          }
        }
      } else {
        // debugPrint("isLoggedIn.....");
        final isUserProfileExists = await ref
            .read(cloudFirestoreController)
            .checkForExistingUserData(firebaseAuth.currentUser!.uid);
        if (isAuthScreenRoute || !isUserProfileExists) {
          if (state.matchedLocation != editProfileScreenPath) {
            // debugPrint("We have entered now in editProfileScreen");
            // debugPrint(
            //     "current route AFTER logic is: ${state.matchedLocation}");
            return editProfileScreenPath;
          }
        } else if (isSplashRoute) {
          if (state.matchedLocation != homeScreenPath) {
            // debugPrint("We have entered now in homescreen");
            // debugPrint(
            //     "current route AFTER logic is: ${state.matchedLocation}");
            return homeScreenPath;
          }
        }
      }
      // debugPrint("Now just normal routing occurs");
      // debugPrint("current route AFTER logic is: ${state.matchedLocation}");
      return null;
    },

    // Automatically refresh the router when the Firebase user state changes
    // refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),
    routes: [
      GoRoute(
        path: splashScreenPath,
        name: AppRoutes.splashScreen.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: permissionsScreenPath,
        name: AppRoutes.permissionsScreen.name,
        builder: (context, state) => const PermissionsScreen(),
      ),
      GoRoute(
        path: homeScreenPath,
        name: AppRoutes.homeScreen.name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
          path: authScreenPath,
          name: AppRoutes.authScreen.name,
          builder: (context, state) => const AuthScreen(),
          routes: [
            GoRoute(
              path: smsCodeScreenPath,
              name: AppRoutes.smsCodeScreen.name,
              builder: (context, state) {
                final phoneNumber =
                    state.pathParameters[PathParams.phoneNumber.name]!;
                final verificationId =
                    state.pathParameters[PathParams.verificationId.name]!;
                return SmsScreen(
                  phoneNumber: phoneNumber,
                  verificationId: verificationId,
                );
              },
            ),
          ]),
      GoRoute(
        path: countrySelectorScreenPath,
        name: AppRoutes.countrySelectorScreen.name,
        builder: (context, state) => const CountrySelectorScreen(),
      ),
      GoRoute(
        path: editProfileScreenPath,
        name: AppRoutes.editProfileScreen.name,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: challengeScreenPath,
        name: AppRoutes.challengeScreen.name,
        builder: (context, state) {
          final name = state.uri.queryParameters['name']!;

          final senderUid = state.uri.queryParameters['senderUid']!;
          final receiverUid = state.uri.queryParameters['receiverUid']!;
          return ChallengeScreen(
              name: name,
              focusStatus: 2,
              senderUid: senderUid,
              receiverUid: receiverUid);
        },
      ),
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
  );
});
