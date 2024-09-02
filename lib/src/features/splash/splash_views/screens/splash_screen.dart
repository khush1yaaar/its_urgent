import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/src/core/views/widgets/elevated_button_with_icon.dart';
import 'package:its_urgent/src/features/splash/splash_providers/splash_screen_provider.dart';
import 'package:its_urgent/src/core/routing/app_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Space between items

            children: [
              // Centered Image
              Expanded(
                child: Center(
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/cropped_image.png',
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              // Rest of the content at the bottom
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(fontWeight: FontWeight.w900),
                      children: [
                        const TextSpan(text: "Welcome to "),
                        TextSpan(
                          text: "It's Urgent",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w900),
                        ),
                        const TextSpan(text: " App"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Tap \"Get Started\" to sign in or create an account using your phone number.",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButtonWithIcon(
                    onPressed: () {
                      ref
                          .read(splashScreenBooleanProvider.notifier)
                          .onSplashScreenRemoved();
                      context.goNamed(AppRoutes.permissionsScreen.name);
                    },
                    lable: 'Get Started',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
