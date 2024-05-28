import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/providers/firebase_auth_provider.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  String _message = "Please verify your email";
  bool _isButtonDisabled = false;
  bool _isEmailVerified = false;
  int _timerSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    ref.read(firebaseAuthProvider);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _sendVerificationEmail(FirebaseAuth auth) async {
    User? user = auth.currentUser;
    await user?.reload();
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    } else if (user != null && user.emailVerified) {
      setState(() {
        _message = "Email already Verified";
        _isEmailVerified = true;
        return;
      });
      return;
    }

    setState(() {
      _message =
          "Email Sent to ${user?.email}, please check your email to verify. Also check spam/junk email.";
      _isButtonDisabled = true;
    });

    _startResendTimer(user);
  }

  void _startResendTimer(User? user) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        await user?.reload();
        if (user?.emailVerified ?? false) {
          setState(() {
            _isEmailVerified = true;
            _message = "Email verified successfully!";
            _isButtonDisabled = true;
            _timer?.cancel();
          });
        } else {
          setState(() {
            _isButtonDisabled = false;
            _timerSeconds = 60;
            _message = "Please verify your email";
          });
        }
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text("Verify your email"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _message,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
              width: double.infinity,
            ),
            ElevatedButton(
              onPressed: _isEmailVerified
                  ? null
                  : _isButtonDisabled
                      ? null
                      : () {
                          _sendVerificationEmail(firebaseAuth);
                        },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary),
              child: Text(
                _isEmailVerified
                    ? "Email already verified"
                    : _isButtonDisabled
                        ? 'Resend Email in $_timerSeconds seconds'
                        : 'Send Verification Email',
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const Text(
              "Once verified or want to go back, Please sign In again",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            OutlinedButton(
              onPressed: () {
                firebaseAuth.signOut();
              },
              child: const Text("Sign In again"),
            )
          ],
        ),
      ),
    );
  }
}
