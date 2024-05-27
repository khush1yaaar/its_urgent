import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/routing/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      context.pushReplacementNamed(AppRoutes.homeScreen.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/cropped_image.png',
            width: 250,
          ),
          const SizedBox(
            width: double.infinity,
            height: 50,
          ),
          Text("It's Urgent !",
              style: Theme.of(context).textTheme.titleMedium!),
        ],
      ),
    );
  }
}
