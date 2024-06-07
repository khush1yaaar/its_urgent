import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:its_urgent/contants/countries.dart';
import 'package:its_urgent/model/country_code_item.dart';

class CustomPhoneInput extends StatefulWidget {
  /// A callback that is being called when the input is submitted.
  final SubmitCallback? onSubmit;

  /// An initial country code that should be selected in the country code
  /// picker.
  final String? initialCountryCode;



  const CustomPhoneInput({
    super.key,
    this.initialCountryCode,
    this.onSubmit,
  });

  @override
  State<CustomPhoneInput> createState() => _CustomPhoneInputState();
}

typedef SubmitCallback = void Function(String value);

class _CustomPhoneInputState extends State<CustomPhoneInput> {
  late final countryController = TextEditingController()
    ..addListener(_onCountryChanged);
  final numberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final numberFocusNode = FocusNode();

  String get phoneNumber =>
      '+${countryController.text}${numberController.text}';

  String? country;
  bool isValidCountryCode = true;

  void _onSubmitted(_) {
    if (formKey.currentState!.validate()) {
      widget.onSubmit?.call(phoneNumber);
    }
  }

  @override
  void initState() {
    _setCountry(countryCode: widget.initialCountryCode);
    super.initState();
  }

  void _setCountry({
    String? phoneCode,
    String? countryCode,
    bool updateCountryInput = true,
  }) {
    try {
      final newItem = countries.firstWhere(
        (element) =>
            element.countryCode == countryCode ||
            element.phoneCode == phoneCode,
      );

      if (phoneCode != null &&
          newItem.phoneCode == countryCodeItem?.phoneCode) {
        return;
      }

      countryCodeItem = newItem;
      isValidCountryCode = true;
    } catch (_) {
      countryCodeItem = null;
      isValidCountryCode = false;
    }

    if (updateCountryInput) {
      countryController.text = countryCodeItem?.phoneCode ?? '';
    }
  }

  void _onCountryChanged() {
    setState(() {
      _setCountry(
        phoneCode: countryController.text,
        updateCountryInput: false,
      );
    });
  }

  CountryCodeItem? countryCodeItem;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          PopupMenuButton<CountryCodeItem>(
            child: Container(
              padding: const EdgeInsets.all(16).copyWith(left: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_drop_down),
                  Text(
                    countryCodeItem?.name?? "",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            itemBuilder: (context) {
              return countries.map((e) {
                return PopupMenuItem(
                  value: e,
                  child: Text('${e.name} (+${e.phoneCode})'),
                );
              }).toList();
            },
            onSelected: (selected) => _setCountry(
              countryCode: selected.countryCode,
            ),
          ),
          const SizedBox(height: 8),
          Directionality(
            textDirection: TextDirection.ltr,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 90,
                    child: TextFormField(
                      autofillHints: const [
                        AutofillHints.telephoneNumberCountryCode
                      ],
                      controller: countryController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      autofillHints: const [
                        AutofillHints.telephoneNumberNational
                      ],
                      autofocus: true,
                      focusNode: numberFocusNode,
                      controller: numberController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
