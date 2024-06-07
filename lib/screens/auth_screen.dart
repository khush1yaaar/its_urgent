import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/providers/selected_country_provider.dart';
import 'package:its_urgent/widgets/countries_selector_button.dart';
import 'package:its_urgent/widgets/phone_code_number_form.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController _phoneCodeController = TextEditingController();
  final FocusNode _phoneNumberFocus = FocusNode();
  final FocusNode _phoneCodeFocus = FocusNode();

  @override
  void dispose() {
    _phoneCodeController.dispose();
    _phoneNumberFocus.dispose();
    _phoneCodeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCountry = ref.watch(selectedCountryProvider);
    // change the phone code to selected country code
    _phoneCodeController.text = selectedCountry?.phoneCode ?? '';

    // once country is found, auto move to next field
    if (selectedCountry != null) {
      FocusScope.of(context).requestFocus(_phoneNumberFocus);
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter your phone number"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "It's Urgent app will need to verify your phone number. Carrier charges may apply.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(
              height: 8,
            ),
            const CountrySelectorButton(),
            PhoneCodeNumberForm(
              size: size,
              selectedCountry: selectedCountry,
              phoneCodeFocus: _phoneCodeFocus,
              phoneNumberFocus: _phoneNumberFocus,
              phoneCodeController: _phoneCodeController,
            ),
          ],
        ),
      ),
    );
  }
}
