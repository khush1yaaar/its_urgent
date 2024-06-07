import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as ui_auth;
import 'package:its_urgent/repositories/phone_auth_repo.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authProvidersrPovider = Provider<List<ui_auth.AuthProvider>>((ref) {
  return 
[ui_auth.PhoneAuthProvider()];
});
final phoneAuthProvider = Provider<PhoneAuthRepo>((ref) {
  return PhoneAuthRepo(ref.watch(firebaseAuthProvider));
});
