import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/cropped_image.png', width: 250,),
          const SizedBox(width: double.infinity, height: 50,),
          Text("It's Urgent !", style: Theme.of(context).textTheme.displayLarge)
        ],
      ),
      
    );
  }
}