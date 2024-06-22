import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/commons/common_providers/firebase_auth_provider.dart';
import 'package:its_urgent/src/features/notification/notification_providers/notification_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {




  @override
  void initState() {
    super.initState();
    ref.read(notificationInstanceProvider).setupToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () async {
              await ref.read(phoneAuthProvider).signOut();
            },
            child: const Text("Sign OUT")),
      ),
    );
  }
}
