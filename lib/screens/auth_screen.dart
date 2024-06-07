import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/widgets/custom_phone_input.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  Widget child = CustomPhoneInput(initialCountryCode: 'US');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter your phone number"),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),

        child: PhoneInputScreen(),
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.stretch,
        //   children: [
        //     Text(
        //       "It's Urgent app will need to verify your phone number. Carrier charges may apply.",
        //       textAlign: TextAlign.center,
        //       style: Theme.of(context).textTheme.labelLarge!.copyWith(
        //           color: Theme.of(context).colorScheme.onSurfaceVariant),
        //     ),
        //     const SizedBox(
        //       height: 8,
        //     ),
        //     PhoneInput(initialCountryCode: 'US',),
        //   ],
        // ),
      ),
    );
  }
}
