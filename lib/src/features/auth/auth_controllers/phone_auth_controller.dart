import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/src/core/controllers/firebase_auth_controller.dart';
import 'package:its_urgent/src/core/controllers/its_urgent_user_controller.dart';
import 'package:its_urgent/src/core/routing/app_router.dart';

class PhoneAuthController {
  final FirebaseAuth _firebaseAuth;
  final ProviderRef _ref;
  PhoneAuthController(this._firebaseAuth, this._ref);

  Future<void> phoneAuthentication(
      BuildContext context, String phoneCode, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "$phoneCode$phoneNumber",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            throw Exception('The provided phone number is not valid.');
          } else {
            throw Exception("Verification failed error message: ${e.message}");
          }
        },
        codeSent: (String verificationId, int? resendToken) {
         Navigator.of(context).pop();
          //remove the dialog
          context.goNamed(
            AppRoutes.smsCodeScreen.name,
            pathParameters: {
              PathParams.phoneNumber.name: "$phoneCode $phoneNumber",
              PathParams.verificationId.name: verificationId
            },
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<dynamic> verifyOtp(String verificationId, String smsCode) async {
    try {
      final userCredential = await _firebaseAuth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode),
      );
      return userCredential.user != null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _ref.read(itsUrgentUserController.notifier).clearCurrentUserOnSignOut();
  }
}


final phoneAuthController = Provider<PhoneAuthController>((ref) {
  return PhoneAuthController(ref.watch(firebaseAuthProvider), ref);
});

