import 'package:its_urgent/src/features/notification/notification_models/app_contact.dart';
import 'package:its_urgent/src/features/notification/notification_models/non_app_contact.dart';

class CombinedContacts {
  final List<AppContact> appContacts;
  final List<NonAppContact> nonAppContacts;

  CombinedContacts({
    required this.appContacts,
    required this.nonAppContacts,
  });
}
