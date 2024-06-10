import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/routing/app_router.dart';

class PhoneAuthRepo {
  final FirebaseAuth _firebaseAuth;
  PhoneAuthRepo(this._firebaseAuth);

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
            print('The provided phone number is not valid.');
          } else {
            print("Verification failed error message: ${e.message}");
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          GoRouter.of(context).pop();
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
      print(e.message);
    }
  }

  Future<bool> verifyOtp(String verificationId, String smsCode) async {
    try {
      final userCredential = await _firebaseAuth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode),
      );
      return userCredential.user != null;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return false;
    }
  }
}
