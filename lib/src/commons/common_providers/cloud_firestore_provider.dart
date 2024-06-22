import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/commons/common_controllers/cloud_firestore_controller.dart';

final cloudFirestoreProvider = Provider<CloudFirestoreController>((ref) {
  return CloudFirestoreController(FirebaseFirestore.instance, ref);
});
