import 'package:flutter/material.dart';

class EmptyContactsWidget extends StatelessWidget {
  const EmptyContactsWidget({
    super.key,
    required this.errorText,
  });

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          errorText,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
        ),
      ),
    );
  }
}
