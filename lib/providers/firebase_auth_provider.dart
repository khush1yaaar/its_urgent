import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as ui_auth;

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final userProvider = StreamProvider<User?>(
  (ref) => ref.watch(firebaseAuthProvider).authStateChanges(),
);

final authProvidersProvider = Provider<List<ui_auth.AuthProvider>>((ref) {
  return [ui_auth.EmailAuthProvider()];
});
