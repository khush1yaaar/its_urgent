import 'package:flutter/material.dart';
import 'package:its_urgent/contants/countries.dart';

class CountrySelectorScreen extends StatefulWidget {
  const CountrySelectorScreen({super.key});

  @override
  State<CountrySelectorScreen> createState() => _CountrySelectorScreenState();
}

class _CountrySelectorScreenState extends State<CountrySelectorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose a country"),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: ListView.separated(
        itemCount: countries.length,
        itemBuilder: (context, index) {
          final country = countries[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              leading: Text(
                country['flag']!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              title: Text(
                country['name']!,
                style: Theme.of(context).textTheme.titleLarge!,
              ),
              trailing: Text(
                country['phoneCode']!,
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
              subtitle: Text(
                country['countryCode']!,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
    );
  }
}
