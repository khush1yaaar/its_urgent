import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/core/views/widgets/elevated_button_with_icon.dart';
import 'package:its_urgent/src/features/auth/auth_providers/selected_country_provider.dart';
import 'package:its_urgent/src/features/auth/auth_views/auth_widgets/confirm_dialog.dart';
import 'package:its_urgent/src/features/auth/auth_views/auth_widgets/countries_selector_button.dart';
import 'package:its_urgent/src/features/auth/auth_views/auth_widgets/phone_number_form.dart';

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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    "It's Urgent app will need to verify your phone number. Carrier charges may apply.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
            ElevatedButtonWithIcon(
              onPressed: selectedCountry != null &&
                      _phoneNumberController.text.isNotEmpty
                  ? () {
                      _showAlertDialog(context, "+${selectedCountry.phoneCode}",
                          _phoneNumberController.text);
                    }
                  : null,
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
