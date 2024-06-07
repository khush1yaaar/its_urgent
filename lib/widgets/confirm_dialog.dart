import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/routing/app_router.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.phoneNumberString,
  });

  final String phoneNumberString;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Is this the correct number',
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      content: Text(
        phoneNumberString,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Edit'),
          onPressed: () {
            
          },
        ),
        TextButton(
          child: const Text('Confirm'),
          onPressed: () {
            context.pop();
            context.goNamed(AppRoutes.smsCodeScreen.name);
          },
        ),
      ],
    );
  }
}
