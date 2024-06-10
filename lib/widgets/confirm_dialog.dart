import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/providers/firebase_auth_provider.dart';

class ConfirmDialog extends ConsumerWidget {
  const ConfirmDialog({
    super.key,
    required this.phoneCode,
    required this.phoneNumber,
  });

  final String phoneCode;
  final String phoneNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text(
        'Is this the correct number',
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      content: Text(
        "$phoneCode $phoneNumber",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Edit'),
          onPressed: () {},
        ),
        TextButton(
          child: const Text('Confirm'),
          onPressed: () async {
            print("$phoneCode$phoneNumber");
            await ref
                .read(phoneAuthProvider)
                .phoneAuthentication(context, phoneCode, phoneNumber.trim());

            // context.goNamed(
            //   AppRoutes.smsCodeScreen.name,
            //   pathParameters: {PathParams.phoneNumber.name: "$phoneCode $phoneNumber"},
            // );
          },
        ),
      ],
    );
  }
}
