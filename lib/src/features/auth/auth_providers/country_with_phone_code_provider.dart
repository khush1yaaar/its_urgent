
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/features/auth/models/class_models/country_code_item.dart';

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
   
  }
}

final selectedCountryWithPhoneCodeProvider =
    NotifierProvider<SelectedCountryWithPhoneCode, CountryWithPhoneCode>(
        () => SelectedCountryWithPhoneCode());
