import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/src/features/auth/auth_providers/selected_country_provider.dart';
import 'package:its_urgent/src/core/routing/app_router.dart';

class CountrySelectorButton extends ConsumerWidget {
  const CountrySelectorButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCountry = ref.watch(selectedCountryProvider);
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                context.pushNamed(AppRoutes.countrySelectorScreen.name);
              },
              style: TextButton.styleFrom(
                  shape: LinearBorder.bottom(),
                  overlayColor: Colors.transparent),
              child: Text(
                selectedCountry == null
                    ? "Choose a country"
                    : selectedCountry.name,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
          Icon(
            Icons.arrow_drop_down,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
