class PermissionsState {
  final bool notification;
  final bool contacts;
  final bool dnd;


  PermissionsState({
    required this.notification,
    required this.contacts,
    required this.dnd,
 
  });

  PermissionsState copyWith({
    bool? notification,
    bool? contacts,
    bool? dnd,
    
  }) {
    return PermissionsState(
      notification: notification ?? this.notification,
      contacts: contacts ?? this.contacts,
      dnd: dnd ?? this.dnd,
    );
  }
}
