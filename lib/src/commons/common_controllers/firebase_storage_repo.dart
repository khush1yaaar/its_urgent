import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

const userImagesPath = 'userImages';

class FirebaseStorageController {
  final FirebaseStorage _firebaseStorage;
  FirebaseStorageController(this._firebaseStorage);

  /// overrides user previous image if already exists or create new image,
  /// because we are using ["$userImagesPath/$uid"], it always overrides that location only specific to the user.
  UploadTask uploadUserImage(String uid, File imageFile) {
    final ref = _firebaseStorage.ref("$userImagesPath/$uid");
    return ref.putFile(imageFile);
  }

  Future<String> getImageUrl(String uid, File imageFile) async {
    final result = await uploadUserImage(uid, imageFile);
    return result.ref.getDownloadURL();
  }
}
