import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/helpers/go_router_refresh_stream.dart';
import 'package:its_urgent/providers/cloud_firestore_provider.dart';
import 'package:its_urgent/providers/firebase_auth_provider.dart';
import 'package:its_urgent/providers/splash_screen_provider.dart';
import 'package:its_urgent/screens/auth_screen.dart';
import 'package:its_urgent/screens/common/error_screen.dart';
import 'package:its_urgent/screens/country_selector_screen.dart';
import 'package:its_urgent/screens/edit_profile_screen.dart';
import 'package:its_urgent/screens/email_verification.dart';
import 'package:its_urgent/screens/home_screen.dart';
import 'package:its_urgent/screens/splash_screen.dart';
import 'package:its_urgent/screens/sms_screen.dart';

// const path parameters name
enum PathParams {
  phoneNumber,
  verificationId,
}

// enum for named routes
enum AppRoutes {
  splashScreen,
  homeScreen,
  authScreen,
  errorScreen,
  // verifyEmailScreen,
  countrySelectorScreen,
  smsCodeScreen,
  editProfileScreen,
}

// Const route paths
const authScreenPath = '/authScreen';
const homeScreenPath = '/homeScreen';
const splashScreenPath = '/';
const errorScreenPath = '/errorScreen';
// const verifyEmailScreenPath = '/verifyEmailScreen';
const countrySelectorScreenPath = '/countrySelectorScreen';
const editProfileScreenPath = '/editProfileScreen';
final smsCodeScreenPath =
    'smsCodeScreen/:${PathParams.phoneNumber.name}/:${PathParams.verificationId.name}';

int appRedirectCount = 0;
// go router provider
final goRouterProvider = Provider<GoRouter>((ref) {
  // Get the instance of FirebaseAuth
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final splashScreenBoolean = ref.watch(splashScreenBooleanProvider);

  return GoRouter(
    initialLocation: splashScreenPath,

    debugLogDiagnostics: true,

    redirect: (context, state) async {
      if (kDebugMode) {
        debugPrint(
            "\n<----- calling redirect function for the  ${++appRedirectCount} ------>");
        debugPrint("current route BEFORE logic is: ${state.matchedLocation}");
      }

      final isLoggedIn = firebaseAuth.currentUser != null;
      final isSplashRoute = state.matchedLocation == splashScreenPath;
      final isHomeScreenPath = state.matchedLocation == homeScreenPath;
      final isAuthScreenPath = state.matchedLocation.startsWith(authScreenPath);

      print("Is logged IN; $isLoggedIn");

      if (!isLoggedIn) {
        debugPrint("We have entered now in not isLoggedIn.....");
        debugPrint("current route AFTER logic is: ${state.matchedLocation}");
        if ((splashScreenBoolean && isSplashRoute) || isHomeScreenPath) {
          if (state.matchedLocation != authScreenPath) {
            debugPrint("We have entered now in authscreepath");
            debugPrint(
                "current route AFTER logic is: ${state.matchedLocation}");
            return authScreenPath;
          }
        } else if (splashScreenBoolean && isAuthScreenPath) {
          debugPrint(
              "We have entered now in state.matched location - verification screen");
          debugPrint("current route AFTER logic is: ${state.matchedLocation}");
          return state.matchedLocation;
        } else if (!splashScreenBoolean) {
          if (state.matchedLocation != splashScreenPath) {
            debugPrint("We have entered now in splashscreen path");
            debugPrint(
                "current route AFTER logic is: ${state.matchedLocation}");
            return splashScreenPath;
          }
        }
      } else {
        debugPrint("isLoggedIn.....");
        final isUserProfileExists = await ref
            .read(cloudFirestoreProvider)
            .checkForExistingUserData(firebaseAuth.currentUser!.uid);
        if (isAuthScreenPath || !isUserProfileExists) {
          if (state.matchedLocation != editProfileScreenPath) {
            debugPrint("We have entered now in editProfileScreen");
            debugPrint(
                "current route AFTER logic is: ${state.matchedLocation}");
            return editProfileScreenPath;
          }
        } else if (isSplashRoute) {
          if (state.matchedLocation != homeScreenPath) {
            debugPrint("We have entered now in homescreen");
            debugPrint(
                "current route AFTER logic is: ${state.matchedLocation}");
            return homeScreenPath;
          }
        }
      }
      debugPrint("Now just normal routing occurs");
      debugPrint("current route AFTER logic is: ${state.matchedLocation}");
      return null;
    },

    // Automatically refresh the router when the Firebase user state changes
    refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),
    routes: [
      GoRoute(
        path: splashScreenPath,
        name: AppRoutes.splashScreen.name,
        builder: (context, state) => const SplashScreen(),
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
      // GoRoute(
      //   path: verifyEmailScreenPath,
      //   name: AppRoutes.verifyEmailScreen.name,
      //   builder: (context, state) => const VerifyEmailScreen(),
      // ),
      GoRoute(
        path: countrySelectorScreenPath,
        name: AppRoutes.countrySelectorScreen.name,
        builder: (context, state) => const CountrySelectorScreen(),
      ),
      GoRoute(
        path: editProfileScreenPath,
        name: AppRoutes.editProfileScreen.name,
        builder: (context, state) => const EditProfileScreen(),
      )
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
  );
});
