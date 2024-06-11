import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/service_repositories/cloud_firestore_repo.dart';

final cloudFirestoreProvider = Provider<CloudFirestoreRepo>((ref) {
  return CloudFirestoreRepo(FirebaseFirestore.instance);
});
