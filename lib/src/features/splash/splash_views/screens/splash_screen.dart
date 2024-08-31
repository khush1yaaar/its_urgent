import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/src/core/controllers/permissions_controller.dart';
import 'package:its_urgent/src/features/splash/splash_providers/splash_screen_provider.dart';
import 'package:its_urgent/src/core/routing/app_router.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/cropped_image.png',
                width: 250,
                height: 250,
              ),
            ),
            const SizedBox(
              width: double.infinity,
              height: 40,
            ),
            Text(
              "Welcome to It's Urgent App",
              style: Theme.of(context).textTheme.titleLarge!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              "Tap \"Get Started\" to sign in or create account using your phone number.",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).colorScheme.outline),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                

                // change the splash screen boolean to true.
                ref
                    .read(splashScreenBooleanProvider.notifier)
                    .onSplashScreenRemoved();
                // // then replace the splash screen route with auth screen route
                context.goNamed(AppRoutes.permissionsScreen.name);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              child: const Text("Get Started"),
            ),
          ],
        ),
      ),
    );
  }
}
