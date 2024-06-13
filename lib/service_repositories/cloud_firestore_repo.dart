import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/providers/its_urgent_user_provider.dart';

const usersCollectionPath = 'users';

enum UserDocFields {
  name,
  imageUrl,
}

class CloudFirestoreRepo {
  final FirebaseFirestore _db;
  // TODO:I am passing Provider ref here, this needs to be improved...
  final ProviderRef _ref;
  CloudFirestoreRepo(this._db, this._ref);

  Future<bool> checkForExistingUserData(String uid) async {
    final user = await _db.collection(usersCollectionPath).doc(uid).get();
    if (user.data() != null) {
      _ref
          .read(itsUrgentUserProvider.notifier)
          .setUpCurrentUserSignedIn(user.data()!);
    }
    return user.exists;
  }

  Future<void> addUser(
      {required String uid,
      required String name,
      required String imageUrl}) async {
    await _db.collection(usersCollectionPath).doc(uid).set({
      UserDocFields.name.name: name,
      UserDocFields.imageUrl.name: imageUrl,
    });
  }

  Future<dynamic> getUserData(String uid) async {
    final doesUserDataExists = await checkForExistingUserData(uid);
    if (doesUserDataExists) {}
  }
}
