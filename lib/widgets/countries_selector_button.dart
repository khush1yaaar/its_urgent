import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/routing/app_router.dart';

class CountrySelectorButton extends StatelessWidget {
  const CountrySelectorButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_drop_down,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          TextButton(
            onPressed: () {
              context.pushNamed(AppRoutes.countrySelectorScreen.name);
            },
            style: TextButton.styleFrom(
                shape: LinearBorder.bottom(), overlayColor: Colors.transparent),
            child: Text(
              "Choose a country",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
