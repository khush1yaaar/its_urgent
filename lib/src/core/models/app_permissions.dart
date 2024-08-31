

class AppPermissions {
   bool contactPermissions;
   bool notificationPermissions;
   bool dndInterruptionPermissions;
   bool isOnceAsked;

  AppPermissions({
    required this.contactPermissions,
    required this.notificationPermissions,
    required this.dndInterruptionPermissions,
    required this.isOnceAsked,
  });

  void setContactPermissions() {
    contactPermissions = true;
  }

  void setNotificationPermissions(bool value) {
    notificationPermissions = value;
  }

  void setDndInterruptionPermissions() {
    dndInterruptionPermissions = true;
  }

  setOnceAsked() {
    isOnceAsked = true;
  }


  

  @override
  String toString() =>
      'Permissions(contactPermissions: $contactPermissions, notificationPermissions: $notificationPermissions, dndAccessPermission: $dndInterruptionPermissions)';
}
