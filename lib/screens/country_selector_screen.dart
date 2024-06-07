import 'package:flutter/material.dart';
import 'package:its_urgent/contants/countries.dart';
import 'package:its_urgent/widgets/countries_list_view.dart';
import 'package:its_urgent/widgets/country_search_bar.dart';

class CountrySelectorScreen extends StatefulWidget {
  const CountrySelectorScreen({super.key});

  @override
  State<CountrySelectorScreen> createState() => _CountrySelectorScreenState();
}

class _CountrySelectorScreenState extends State<CountrySelectorScreen> {
  List<Map<String, String>> _filteredCountries = [];
  bool searchIconPressed = false;

  Widget appBarChild = const Text("Choose a country");

  @override
  void initState() {
    super.initState();
    _filteredCountries = countries;
  }

  void _filter(String searchText) {
    List<Map<String, String>> searchResults = [];
    if (searchText.isEmpty) {
      searchResults = countries;
    } else {
      searchResults = countries.where((country) {
        return country['name']!.toLowerCase().contains(searchText) ||
            country['phoneCode']!.contains(searchText) ||
            country['countryCode']!.toLowerCase().contains(searchText);
      }).toList();
    }

    setState(() {
      _filteredCountries = searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarChild,
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        actions: [
          IconButton(
            onPressed: searchIconPressed
                ? () {
                    setState(() {
                      searchIconPressed = false;
                      appBarChild = const Text("Choose a country");
                    });
                  }
                : () {
                    setState(() {
                      searchIconPressed = true;
                      appBarChild = ContrySearchBar(filter: _filter);
                    });
                  },
            icon: Icon(searchIconPressed ? Icons.close : Icons.search),
          ),
        ],
      ),
      body: _filteredCountries.isEmpty
          ? const Center(
              child: Text("No Match found"),
            )
          : CountriesListView(filteredCountries: _filteredCountries),
    );
  }
}