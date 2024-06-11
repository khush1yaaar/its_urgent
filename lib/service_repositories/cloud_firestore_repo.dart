import 'package:cloud_firestore/cloud_firestore.dart';

const usersCollectionPath = 'users';

enum UserDocFields {
  name,
  imageUrl,
}

class CloudFirestoreRepo {
  final FirebaseFirestore _db;
  CloudFirestoreRepo(this._db);

  Future<bool> checkForExistingUserData(String uid) async {
    final user = await _db.collection(usersCollectionPath).doc(uid).get();
    return user.exists;
  }

  Future<void> addJob(
      {required String uid,
      required String name,
      required String imageUrl}) async {
    await _db.collection(usersCollectionPath).doc(uid).set({
      UserDocFields.name.name: name,
      UserDocFields.imageUrl.name: imageUrl,
    });
  }
}
