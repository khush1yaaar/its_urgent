import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/service_repositories/firebase_storage_repo.dart';

final firebaseStorageProvider = Provider<FirebaseStorageRepo>((ref) {
  return FirebaseStorageRepo(FirebaseStorage.instance);
});
