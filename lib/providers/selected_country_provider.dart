import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/model/country_code_item.dart';

class SelectedCountry extends Notifier<CountryCodeItem?> {
  @override
  CountryCodeItem? build() {
    return null;
  }

  void changeCountry(Map<String, String> data) {
    state = CountryCodeItem.fromJson(data);
  }
}

final selectedCountryProvider =
    NotifierProvider<SelectedCountry, CountryCodeItem?>(
        () => SelectedCountry());

///
/// selectedCountry Index provider for autoscroll
///
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
