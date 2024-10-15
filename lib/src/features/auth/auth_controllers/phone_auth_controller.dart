import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/src/core/controllers/firebase_auth_controller.dart';
import 'package:its_urgent/src/core/controllers/its_urgent_user_controller.dart';
import 'package:its_urgent/src/core/routing/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          _ref.read(currentUserPhoneController.notifier).clearCurrentUserPhone();
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
      _ref.read(currentUserPhoneController.notifier).clearCurrentUserPhone();
      throw Exception(e.message);
    }
  }

  Future<dynamic> verifyOtp(String verificationId, String smsCode, String phoneNumber) async {
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
    _ref.read(currentUserPhoneController.notifier).clearCurrentUserPhone();
  }
}

final phoneAuthController = Provider<PhoneAuthController>((ref) {
  return PhoneAuthController(ref.watch(firebaseAuthProvider), ref);
});


class CurrentUserPhoneController extends AsyncNotifier<String?> {
  static const _phoneKey = 'current_user_phone'; // Key for local storage

  @override
  Future<String?> build() async {
    return await _loadPhoneFromStorage(); // Load phone from storage
  }

  /// Updates the current user phone and saves it to local storage.
  Future<void> updateCurrentUserPhone(String phone) async {
    state = AsyncLoading(); // Set loading state
    try {
      log("updating phone number: $phone");
      await _savePhoneToStorage(phone); // Save phone to local storage
      state = AsyncData(phone); // Update state with the new phone number
    } catch (e, st) {
      state = AsyncError(e, st); // Handle any errors
    }
  }

  /// Clears the current user phone from state and local storage.
  Future<void> clearCurrentUserPhone() async {
    state = AsyncLoading(); // Set loading state
    try {
      await _removePhoneFromStorage(); // Remove phone from local storage
      state = const AsyncData(null); // Clear the state
    } catch (e, st) {
      state = AsyncError(e, st); // Handle errors
    }
  }

  /// Asynchronously loads the phone number from local storage.
  Future<String?> _loadPhoneFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneKey);
  }

  /// Saves the phone number to local storage.
  Future<void> _savePhoneToStorage(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneKey, phone);
  }

  /// Removes the phone number from local storage.
  Future<void> _removePhoneFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_phoneKey);
  }
}

// Provider for the CurrentUserPhoneController
final currentUserPhoneController =
    AsyncNotifierProvider<CurrentUserPhoneController, String?>(
  () => CurrentUserPhoneController(),
);
