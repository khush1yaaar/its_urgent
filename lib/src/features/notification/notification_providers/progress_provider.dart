import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/features/notification/notification_controllers/progress_controller.dart';

final progressProvider = AsyncNotifierProvider<ProgressController, bool>(() {
  return ProgressController();
});