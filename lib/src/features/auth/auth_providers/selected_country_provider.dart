import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/features/auth/auth_providers/country_with_phone_code_provider.dart';
import 'package:its_urgent/src/features/auth/models/data_constants/countries.dart';
import 'package:its_urgent/src/features/auth/models/class_models/country_code_item.dart';

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



/// 3. Notifier & NotifierProvider
/// selectedCountryWithPhoneCode type[CountryWithPhoneCode] for formatting & validating phone number for every country.
///
