import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/core/models/its_urgent_user.dart';
import 'package:its_urgent/src/core/models/user_ref.dart';
import 'package:its_urgent/src/core/controllers/firebase_auth_controller.dart';
import 'package:its_urgent/src/core/controllers/its_urgent_user_controller.dart';
import 'package:its_urgent/src/features/auth/models/class_models/challenge.dart';
import 'package:its_urgent/src/features/notification/notification_models/app_contact.dart';

const usersCollectionPath = 'users';
const usersRefCollectionPath = 'usersRef';

class CloudFirestoreController {
  final FirebaseFirestore _db;
  final ProviderRef _ref;
  CloudFirestoreController(this._db, this._ref);

  Future<bool> checkForExistingUserData(String uid) async {
    final user = await _db.collection(usersCollectionPath).doc(uid).get();
     if (user.data() != null) {
      final userData = {
        UserDocFields.uid.name: uid,
        ...user.data()!,
      };
    
      _ref
          .read(itsUrgentUserController.notifier)
          .updateUserDetails(userData);
    }
    
    return user.exists;
  }

  Future<void> addUser(
      {required String uid,
      required String name,
      required String imageUrl, required Challenge challenge}) async {
    await _db.collection(usersCollectionPath).doc(uid).set(
      {
        UserDocFields.name.name: name,
        UserDocFields.imageUrl.name: imageUrl,
        UserDocFields.question.name: challenge.question,
        UserDocFields.answer.name: challenge.answer,
        UserDocFields.answerType.name: challenge.answerType,
      },
      SetOptions(merge: true),
    );

    
  }

  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    String userId = _ref.read(firebaseAuthProvider).currentUser!.uid;

    await _db.collection(usersCollectionPath).doc(userId).set(
      {
        UserDocFields.deviceToken.name: token,
      },
      SetOptions(merge: true),
    );

    // Update the device token in the user object
    _ref.read(itsUrgentUserController.notifier).updateUserDetails({
      UserDocFields.deviceToken.name: token,
    });
  }

  Future<List<UserRef>> fetchUsersRefs() async {
    List<UserRef> usersRefs = [];
    try {
      QuerySnapshot querySnapshot =
          await _db.collection(usersRefCollectionPath).get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        final user = UserRef(
          uid: doc[UserRefFields.uid.name],
          phoneNumber: doc.id,
        );
        usersRefs.add(user);
      }
    } catch (error) {
      log("Error retrieving Firestore data: $error");
    }
    return usersRefs;
  }

  Future<List<AppContact>> fetchUsersFromFirestore(
      List<UserRef> userRefs) async {
    final Map<String, String> userIdToPhoneNumber = {
      for (var userRef in userRefs) userRef.uid: userRef.phoneNumber
    };

    // Check if the userRefs list is empty
  if (userRefs.isEmpty) {
    log("No user references provided. Skipping Firestore query.");
    return []; // Return an empty list to avoid the query.
  }

    final List<AppContact> users = [];
    try {
      final List<UserUid> userIds =
          userRefs.map((userRef) => userRef.uid).toList();

      final QuerySnapshot querySnapshot = await _db
          .collection(usersCollectionPath)
          .where(FieldPath.documentId, whereIn: userIds)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        final user = AppContact(
          uid: doc.id,
          name: doc[UserDocFields.name.name],
          imageUrl: doc[UserDocFields.imageUrl.name],
          deviceToken: doc[UserDocFields.deviceToken.name],
          phoneNumber: userIdToPhoneNumber[doc.id]!,
          question: doc[UserDocFields.question.name] ?? "No question",
          answer: doc[UserDocFields.answer.name] ?? "No answer",
          answerType: doc[UserDocFields.answerType.name] ?? "No answer type",
          
         
        );
        users.add(user);
      }
    } catch (e) {
      log("Error fetching users from Firestore (error here): $e");
    }

    return users;
  }
}


final cloudFirestoreController = Provider<CloudFirestoreController>((ref) {
  return CloudFirestoreController(FirebaseFirestore.instance, ref);
});
