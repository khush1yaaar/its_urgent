import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:its_urgent/service_repositories/phone_auth_repo.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});


final phoneAuthProvider = Provider<PhoneAuthRepo>((ref) {
  return PhoneAuthRepo(ref.watch(firebaseAuthProvider), ref);
});
