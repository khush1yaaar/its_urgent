import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/features/notification/notification_controllers/cloud_function_controller.dart';

final cloudFunctionProvider = Provider<CloudFunctionController>((ref) {
  return CloudFunctionController(FirebaseFunctions.instance );
});