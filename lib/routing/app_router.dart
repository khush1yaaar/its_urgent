import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/helpers/go_router_refresh_stream.dart';
import 'package:its_urgent/providers/firebase_auth_provider.dart';
import 'package:its_urgent/screens/auth_screen.dart';
import 'package:its_urgent/screens/common/error_screen.dart';
import 'package:its_urgent/screens/home_screen.dart';
import 'package:its_urgent/screens/splash_screen.dart';

// enum for named routes
enum AppRoutes { splashScreen, homeScreen, authScreen, errorScreen }

// Const route paths
const authScreenPath = '/authScreen';
const homeScreenPath = '/homeScreen';
const splashScreenPath = '/';
const errorScreenPath = '/errorScreen';

// go router provider
final goRouterProvider = Provider<GoRouter>((ref) {
  // Get the instance of FirebaseAuth
  final firebaseAuth = ref.watch(firebaseAuthProvider);

  return GoRouter(
    initialLocation: splashScreenPath,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Check if the user is logged in
      final isLoggedIn = firebaseAuth.currentUser != null;
      // Determine if the current route is the splash screen
      final isSplashRoute = state.matchedLocation == splashScreenPath;

      // Determine if the current route is the authentication screen
      final isAuthRoute = state.matchedLocation == authScreenPath;

      // If the user is not logged in and is not already on the authentication screen
      if (!isLoggedIn && !isAuthRoute) {
        // Redirect to the authentication screen
        return authScreenPath;
      }
      // If the user is logged in and is on the splash screen or authentication screen
      else if (isLoggedIn && (isSplashRoute || isAuthRoute)) {
        // Redirect to the home screen
        return homeScreenPath;
      }
      // No redirection needed, proceed with the current navigation
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
      ),
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
  );
});
