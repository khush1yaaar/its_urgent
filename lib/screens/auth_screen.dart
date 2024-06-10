import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/providers/selected_country_provider.dart';
import 'package:its_urgent/widgets/confirm_dialog.dart';
import 'package:its_urgent/widgets/countries_selector_button.dart';
import 'package:its_urgent/widgets/phone_number_form.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController _phoneCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  void _updateButtonState() {
    setState(() {});
  }

  void _showAlertDialog(
      BuildContext context, String phoneCode, String phoneNumber) async {
    bool wrongNumberFormat = true;
    try {
      await parse("+$phoneCode$phoneNumber");
      wrongNumberFormat = false;
    } catch (e) {
      print(e.toString());
      wrongNumberFormat = true;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          phoneCode: phoneCode,
          phoneNumber: phoneNumber,
          isWrongNumberFormat: wrongNumberFormat,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _phoneNumberController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _phoneCodeController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCountry = ref.watch(selectedCountryProvider);
    // change the phone code to selected country code
    _phoneCodeController.text = selectedCountry?.phoneCode ?? '';

    // once country is found, auto move to next field

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter your phone number"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
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
                  PhoneNumberForm(
                    size: size,
                    selectedCountry: selectedCountry,
                    phoneCodeController: _phoneCodeController,
                    phoneNumberController: _phoneNumberController,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: selectedCountry != null &&
                      _phoneNumberController.text.isNotEmpty
                  ? () {
                      _showAlertDialog(context, "+${selectedCountry.phoneCode}",
                          _phoneNumberController.text);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
