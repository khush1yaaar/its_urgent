import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:its_urgent/src/features/auth/auth_controllers/phone_auth_controller.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final phoneAuthProvider = Provider<PhoneAuthController>((ref) {
  return PhoneAuthController(ref.watch(firebaseAuthProvider), ref);
});
