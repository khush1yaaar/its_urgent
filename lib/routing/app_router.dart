import 'package:go_router/go_router.dart';
import 'package:its_urgent/screens/home_screen.dart';
import 'package:its_urgent/screens/splash_screen.dart';

enum AppRoutes {
  splashScreen,
  homeScreen,
}

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      name: AppRoutes.splashScreen.name,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/homeScreen',
      name: AppRoutes.homeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
