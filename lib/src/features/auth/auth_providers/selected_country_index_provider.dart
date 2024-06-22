import 'package:flutter_riverpod/flutter_riverpod.dart';

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
