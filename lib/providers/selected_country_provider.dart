import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/constants/countries.dart';
import 'package:its_urgent/model/country_code_item.dart';

/// 1.selectedCountry Notifier & NotifierProvider
/// Type[CountryCodeItem] which is implemented from
/// Google's firebase phone auth ui package's internal code. See lib/models country_code_item.dart for more details.
class SelectedCountry extends Notifier<CountryCodeItem?> {
  // when app is initialized, selected country is null
  @override
  CountryCodeItem? build() {
    return null;
  }

  /// this function is called when country is selected from [CountrySelectorScreen]
  void changeCountry(Map<String, String> data) async {
    final country = CountryCodeItem.fromJson(data);
    state = country;
    ref
        .read(selectedCountryWithPhoneCodeProvider.notifier)
        .changeCountryWithPhoneCode(country);
  }

  /// this function is called when country is selected by manually typing the 
  /// [CountryCodeItem.phoneCode] in [AuthScreen]
  void changeCountryThroughPhoneCode(String phoneCode) {
    if (phoneCode.isEmpty) {
      state = null;
    }
    final Map<String, String> country = countries.firstWhere(
      (country) => country['phoneCode'] == phoneCode,
      orElse: () => {'name': "null"}, // Return null if no country is found
    );

    if (country['name'] == "null") {
      state = null;
    } else {
      changeCountry(country);
    }
  }
}

final selectedCountryProvider =
    NotifierProvider<SelectedCountry, CountryCodeItem?>(
        () => SelectedCountry());

/// 2. Notifier & NotifierProvider
/// selectedCountry Index provider for autoscroll or moving the selected country 
/// to the the top of the list.
/// type is int
class SelectedCountryIndex extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void changeCountryIndex(int index) {
    state = index;
  }
}

final selectedCountryIndexProvider =
    NotifierProvider<SelectedCountryIndex, int>(() => SelectedCountryIndex());

/// 3. Notifier & NotifierProvider
/// selectedCountryWithPhoneCode type[CountryWithPhoneCode] for formatting & validating phone number for every country.
///
class SelectedCountryWithPhoneCode extends Notifier<CountryWithPhoneCode> {
  @override
  CountryWithPhoneCode build() {
    return const CountryWithPhoneCode.us();
  }

  /// This function is called by [SelectedCountry.changeCountry] notifer
  /// method above whenever selected country is changed to update the formatter
  /// & validator for that country; if not found, defaults to US.
  Future<void> changeCountryWithPhoneCode(
      CountryCodeItem countryCodeItem) async {
    final res = await getAllSupportedRegions();
    if (res[countryCodeItem.countryCode] == null) {
      state = const CountryWithPhoneCode.us();
    } else {
      state = res[countryCodeItem.countryCode]!;
    }
    // print for debugging purposes
    print(state);
  }
}

final selectedCountryWithPhoneCodeProvider =
    NotifierProvider<SelectedCountryWithPhoneCode, CountryWithPhoneCode>(
        () => SelectedCountryWithPhoneCode());
