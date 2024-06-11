import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/constants/countries.dart';
import 'package:its_urgent/providers/selected_country_provider.dart';

class CountriesListView extends ConsumerStatefulWidget {
  const CountriesListView({
    super.key,
    required List<Map<String, String>> filteredCountries,
  }) : _filteredCountries = filteredCountries;

  final List<Map<String, String>> _filteredCountries;

  @override
  ConsumerState<CountriesListView> createState() => _CountriesListViewState();
}

class _CountriesListViewState extends ConsumerState<CountriesListView> {
  @override
  Widget build(BuildContext context) {
    final selectedCountry = ref.watch(selectedCountryProvider);

    return ListView.separated(
      itemCount: widget._filteredCountries.length,
      itemBuilder: (context, index) {
        final country = widget._filteredCountries[index];

        return ListTile(
          onTap: () {
            ref.read(selectedCountryProvider.notifier).changeCountry(country);
            // _moveToTop(country['name']!);
            context.pop();
          },
          selected: selectedCountry?.name == country['name'],
          selectedTileColor: Theme.of(context).colorScheme.inversePrimary,
          leading: Text(
            country['flag']!,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          title: Text(
            country['name']!,
            style: Theme.of(context).textTheme.titleLarge!,
          ),
          trailing: Text(
            "+${country['phoneCode']!}",
            style: Theme.of(context).textTheme.bodyLarge!,
          ),
          subtitle: Text(
            country['countryCode']!,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }

  // void _moveToTop(String countryName) {
  //   final int index = countries
  //       .indexWhere((country) => country['name'] == countryName);
  //   final previousIndex = ref.watch(selectedCountryIndexProvider);
  //   if (index != -1) {
  //     setState(() {
  //       if (previousIndex != null && previousIndex != 0) {
  //         // Move the previously selected country back to its original position
  //         final movedCountry = countries.removeAt(0);
  //         countries.insert(previousIndex, movedCountry);
  //       }
  //       final selectedCountry = countries.removeAt(index);
  //       countries.insert(0, selectedCountry);

  //       ref
  //           .read(selectedCountryIndexProvider.notifier)
  //           .changeCountryIndex(index);
  //     });
  //   }
  // }
}
