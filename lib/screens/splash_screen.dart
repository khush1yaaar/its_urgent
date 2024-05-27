import 'package:flutter/material.dart';
import 'package:its_urgent/screens/home_screen.dart';

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
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
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
          Text("It's Urgent !", style: Theme.of(context).textTheme.titleMedium!),
        ],
      ),
    );
  }
}
