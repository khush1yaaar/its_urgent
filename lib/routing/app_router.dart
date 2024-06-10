import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/helpers/go_router_refresh_stream.dart';
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
  verifyEmailScreen,
  countrySelectorScreen,
  smsCodeScreen,
  editProfileScreen,
}

// Const route paths
const authScreenPath = '/authScreen';
const homeScreenPath = '/homeScreen';
const splashScreenPath = '/';
const errorScreenPath = '/errorScreen';
const verifyEmailScreenPath = '/verifyEmailScreen';
const countrySelectorScreenPath = '/countrySelectorScreen';
final smsCodeScreenPath =
    'smsCodeScreen/:${PathParams.phoneNumber.name}/:${PathParams.verificationId.name}';
final editProfileScreenPath = '/editProfileSceenPath';
// go router provider
final goRouterProvider = Provider<GoRouter>((ref) {
  // Get the instance of FirebaseAuth
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final splashScreenBoolean = ref.watch(splashScreenBooleanProvider);

  // TODO - set the routing logic back to normal
  return GoRouter(
    initialLocation: splashScreenPath,
    // initialLocation: "$authScreenPath/$smsCodeScreenPath",
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // check if the user is logged in
      final isLoggedIn = firebaseAuth.currentUser != null;

      // Determine if the current route is the splash screen
      final isSplashRoute = state.matchedLocation == splashScreenPath;

      //   // Determine if the current route is the authentication screen
      final isHomeScreenPath = state.matchedLocation == homeScreenPath;

      if (!isLoggedIn) {
        if ((splashScreenBoolean && isSplashRoute) || isHomeScreenPath) {
          return authScreenPath;
        } else if (splashScreenBoolean &&
            state.matchedLocation.startsWith(authScreenPath)) {
          return state.matchedLocation; // for verification sms screen
        } else if (!splashScreenBoolean) {
          return splashScreenPath;
        }
      } else if (isLoggedIn &&
          (state.matchedLocation.startsWith(authScreenPath) || isSplashRoute)) {
        return homeScreenPath;
        // editprofile screen path;
      }
      // else if (is logged && (is splash route or edit profile screen route) ) => homne screen path

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
      GoRoute(
        path: verifyEmailScreenPath,
        name: AppRoutes.verifyEmailScreen.name,
        builder: (context, state) => const VerifyEmailScreen(),
      ),
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
