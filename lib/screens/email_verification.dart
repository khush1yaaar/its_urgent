import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/providers/firebase_auth_provider.dart';

class VerifyEmailScreen extends ConsumerWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text("Verify your email"),
      ),
      body: EmailVerificationScreen(
        actions: [
          EmailVerifiedAction(() {}),
          AuthCancelledAction((context) {
            firebaseAuth.signOut();
          })
        ],
      ),
    );
  }
}
