import 'package:cloud_functions/cloud_functions.dart';
import 'package:its_urgent/src/commons/common_models/common_class_models/user_ref.dart';

class CloudFunctionController {
  final FirebaseFunctions _functions;
  CloudFunctionController(this._functions);

  Future<void> testFunction() async {
    final HttpsCallable callable = _functions.httpsCallable('testFunction');
    try {
      final HttpsCallableResult result = await callable();
      print(result.data);
    } catch (e) {
      print('Exception: $e');
    }
  }

  // this function is called when the current user wants to get the focus status of another user,
  // usually called by tapping on the user contact listTile
  Future<void> getFocusStatus(
      {required UserUid senderUid, required UserUid receiverUid}) async {
    final data = {
      'senderUid': senderUid,
      'receiverUid': receiverUid,
    };

    final HttpsCallable callable = _functions.httpsCallable('getFocusStatus');
    try {
      final HttpsCallableResult result = await callable(data);
      print(result.data);
    } catch (e) {
      print('Exception: $e');
    }
  }

 
}
