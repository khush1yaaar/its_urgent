import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/src/commons/common_controllers/permissions_controller.dart';
import 'package:its_urgent/src/core/routing/app_router.dart';

class PermissionsScreen extends ConsumerStatefulWidget {
  const PermissionsScreen({super.key});

  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen> {
  @override
  Widget build(BuildContext context) {
    final appPermission = ref.watch(permissionsControllerProvider);
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
              appPermission.isOnceAsked
                  ? "Please provide the following permissions to continue:"
                  : "Tap the button below to ask all the permissions.",
              style: Theme.of(context).textTheme.titleMedium!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            !appPermission.isOnceAsked
                ? Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      onPressed: () {
                        ref
                            .read(permissionsControllerProvider.notifier)
                            .initPermissions();
                      },
                      child: const Text('Ask Permissions'),
                    ),
                  )
                : Expanded(
                    child: ListView(
                      children: [
                        appPermission.contactPermissions.when(
                          data: (value) => ListTile(
                            leading: const Icon(Icons.contacts),
                            title: const Text('Contact Permissions'),
                            subtitle: value
                                ? const Text("Granted.")
                                : const Text(
                                    "Tap to open app settings -> Permissions -> Contacts -> Allow. Then Tap again to refresh."),
                            trailing: Checkbox(
                              value: value,
                              onChanged: value ? (bool? value) {} : null,
                            ),
                            onTap: value
                                ? null
                                : () {
                                    ref
                                        .read(permissionsControllerProvider
                                            .notifier)
                                        .setContactPermission();
                                  },
                          ),
                          loading: () => const ListTile(
                            leading: Icon(Icons.contacts),
                            title: Text('Contact Permissions'),
                            subtitle: Text("Loading..."),
                            trailing: CircularProgressIndicator(),
                          ),
                          error: (error, stackTrace) => const ListTile(
                            leading: Icon(Icons.contacts),
                            title: Text('Contact Permissions Error'),
                            subtitle:
                                Text('Error loading contact permissions.'),
                            trailing: Icon(Icons.error),
                          ),
                        ),
                        appPermission.notificationPermissions.when(
                          data: (value) => ListTile(
                            leading: const Icon(Icons.notifications),
                            title: const Text('Notification Permissions'),
                            subtitle: value
                                ? const Text("Granted.")
                                : const Text(
                                    "Tap to open Notification settings -> Switch On. Then Tap again to refresh."),
                            trailing: Checkbox(
                              value: value,
                              onChanged: value ? (bool? value) {} : null,
                            ),
                            onTap: value
                                ? null
                                : () {
                                    ref
                                        .read(permissionsControllerProvider
                                            .notifier)
                                        .setNotificationPermission();
                                  },
                          ),
                          loading: () => const ListTile(
                            leading: const Icon(Icons.notifications),
                            title: Text('Notification Permissions'),
                            subtitle: Text('Loading...'),
                            trailing: CircularProgressIndicator(),
                          ),
                          error: (error, stackTrace) => const ListTile(
                            leading: const Icon(Icons.notifications),
                            title: Text('Notification Permissions'),
                            subtitle:
                                Text("Error loading notification permissions."),
                            trailing: Icon(Icons.error),
                          ),
                        ),
                        appPermission.dndAccessPermissions.when(
                          data: (value) => ListTile(
                            title:
                                const Text('Do Not Disturb Access Permission'),
                            trailing: Checkbox(
                              value: value,
                              onChanged: value ? (bool? value) {} : null,
                            ),
                            onTap: value
                                ? null
                                : () {
                                    ref
                                        .read(permissionsControllerProvider
                                            .notifier)
                                        .setDndAccessPermission();
                                  },
                          ),
                          loading: () => const ListTile(
                            title: Text('Do Not Disturb Access Permission'),
                            trailing: CircularProgressIndicator(),
                          ),
                          error: (error, stackTrace) => const ListTile(
                            title: Text('Do Not Disturb Access Permission'),
                            trailing: Icon(Icons.error),
                          ),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(permissionsControllerProvider.notifier).updatePermissions();
          context.goNamed(AppRoutes.authScreen.name);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
