import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/commons/common_controllers/firebase_storage_repo.dart';

final firebaseStorageProvider = Provider<FirebaseStorageController>((ref) {
  return FirebaseStorageController(FirebaseStorage.instance);
});
