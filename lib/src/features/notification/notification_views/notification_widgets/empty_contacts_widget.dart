import 'package:flutter/material.dart';

class EmptyContactsWidget extends StatelessWidget {
  const EmptyContactsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "None of your contacts is currently on It's Urgent App. \n\nAsk Your Contacts to download the app & sign in using their phone number.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
        ),
      ),
    );
  }
}
