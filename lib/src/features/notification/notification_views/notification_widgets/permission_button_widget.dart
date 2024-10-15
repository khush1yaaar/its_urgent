import 'package:flutter/material.dart';

class PermissionButtonWidget extends StatelessWidget {
  const PermissionButtonWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final IconData iconData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        shape: RoundedRectangleBorder(
          side:
              BorderSide(color: Theme.of(context).colorScheme.error, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(
          iconData,
          color: Theme.of(context).colorScheme.error,
        ),
        onTap: onPressed,
      ),
    );
  }
}
