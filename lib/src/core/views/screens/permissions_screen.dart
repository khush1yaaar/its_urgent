import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:its_urgent/src/core/views/widgets/device_contacts_permission_widget.dart';
import 'package:its_urgent/src/core/views/widgets/dnd_override_permission_widget.dart';
import 'package:its_urgent/src/core/views/widgets/notification_permissions_widget.dart';

class PermissionsScreen extends ConsumerStatefulWidget {
  const PermissionsScreen({super.key});

  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/cropped_image.png',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(
              width: double.infinity,
              height: 40,
            ),
            Text(
              "Please provide the following permissions to continue:",
              style: Theme.of(context).textTheme.titleMedium!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: ListView(
                children: const [
                  NotificationPermissionsWidget(),
                  SizedBox(
                    height: 16,
                  ),
                  DeviceContactsPermissionsWidget(),
                  SizedBox(
                    height: 16,
                  ),
                  DndOverridePermissionWidget(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
