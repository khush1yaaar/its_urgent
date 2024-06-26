import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/commons/common_models/common_class_models/its_urgent_user.dart';
import 'package:its_urgent/src/commons/common_models/common_class_models/user_ref.dart';
import 'package:its_urgent/src/commons/common_providers/firebase_auth_provider.dart';
import 'package:its_urgent/src/commons/common_providers/its_urgent_user_provider.dart';
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
          .read(itsUrgentUserProvider.notifier)
          .updateUserDetails(userData);
    }
    
    return user.exists;
  }

  Future<void> addUser(
      {required String uid,
      required String name,
      required String imageUrl}) async {
    await _db.collection(usersCollectionPath).doc(uid).set(
      {
        UserDocFields.name.name: name,
        UserDocFields.imageUrl.name: imageUrl,
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
    _ref.read(itsUrgentUserProvider.notifier).updateUserDetails({
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
      print("Error retrieving Firestore data: $error");
    }
    return usersRefs;
  }

  Future<List<AppContact>> fetchUsersFromFirestore(
      List<UserRef> userRefs) async {
    final Map<String, String> userIdToPhoneNumber = {
      for (var userRef in userRefs) userRef.uid: userRef.phoneNumber
    };

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
        );
        users.add(user);
      }
    } catch (e) {
      print("Error fetching users from Firestore: $e");
    }

    return users;
  }
}
