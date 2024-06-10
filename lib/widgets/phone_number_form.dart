import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/model/country_code_item.dart';
import 'package:its_urgent/providers/selected_country_provider.dart';

class PhoneNumberForm extends ConsumerWidget {
  const PhoneNumberForm({
    super.key,
    required this.size,
    required this.selectedCountry,
    required TextEditingController phoneCodeController,
    required TextEditingController phoneNumberController,
   
  })  : _phoneCodeController = phoneCodeController,
        _phoneNumberController = phoneNumberController;

  final Size size;
  final CountryCodeItem? selectedCountry;
  final TextEditingController _phoneNumberController;
  final TextEditingController _phoneCodeController;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size.width * 0.2,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 1.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                  child: Icon(
                Icons.add,
                size: 16,
              )),
              Expanded(
                  flex: 2,
                  child: TextFormField(
                    onChanged: (value) {
                      ref
                          .read(selectedCountryProvider.notifier)
                          .changeCountryThroughPhoneCode(value);
                    },
                    onEditingComplete: () {
                      if (selectedCountry != null) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    autofocus: true,
                    controller: _phoneCodeController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                  ))
            ],
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        SizedBox(
          width: size.width * 0.4,
          child: TextFormField(
            controller: _phoneNumberController,
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            },
            decoration: const InputDecoration(hintText: "Phone Number"),
            inputFormatters: [
              LengthLimitingTextInputFormatter(17),
              FilteringTextInputFormatter.digitsOnly,
              LibPhonenumberTextFormatter(
                country: ref.watch(selectedCountryWithPhoneCodeProvider),

                // example for an indian phone number
                // country: CountryWithPhoneCode(
                //     countryName: "India",
                //     countryCode: "IN",
                //     phoneCode: "91",
                //     exampleNumberMobileNational: "081234 56789",
                //     exampleNumberFixedLineNational: "074104 10123",
                //     phoneMaskMobileNational: "000000 00000",
                //     phoneMaskFixedLineNational: "000000 00000",
                //     exampleNumberMobileInternational: "+91 81234 56789",
                //     exampleNumberFixedLineInternational: "+91 74104 10123",
                //     phoneMaskMobileInternational: "+00 00000 00000",
                //     phoneMaskFixedLineInternational: "+00 00000 00000"),
              )
            ],
            keyboardType: TextInputType.phone,
          ),
        )
      ],
    );
  }
}
