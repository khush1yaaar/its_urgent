import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/commons/common_providers/cloud_firestore_provider.dart';

class NotificationController {
  final FirebaseMessaging _firebaseMessaging;
  final ProviderRef _ref;

  const NotificationController(this._firebaseMessaging, this._ref);

  Future<void> setupToken() async {
    // Get the token each time the application loads
    String? token = await _firebaseMessaging.getToken();

    // Save the token to the database function from cloud firestore controller
    final saveToken = _ref.read(cloudFirestoreProvider).saveTokenToDatabase;


    // Save the initial token to the database
    await saveToken(token!);

    // Any time the token refreshes, store this in the database too.
    _firebaseMessaging.onTokenRefresh.listen(saveToken);
  }

 
}
