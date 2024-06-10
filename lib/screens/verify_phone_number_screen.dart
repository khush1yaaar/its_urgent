import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:its_urgent/widgets/pinput_constants.dart';
import 'package:pinput/pinput.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  const VerifyPhoneNumberScreen({super.key, required this.phoneNumber});
  final String phoneNumber;

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
  String _progressOrErrorText = "";
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifying you number"),
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
                    "SMS code sent to \"${widget.phoneNumber}\". Waiting to automatically detect the SMS or you can enter the code below manually.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Pinput(
                    autofocus: true,
                    focusNode: focusNode,
                    controller: controller,
                    length: 6,
                    cursor: pinputCursor(context),
                    defaultPinTheme: pinputPinTheme(context),
                    pinAnimationType: PinAnimationType.slide,
                    preFilledWidget: pinputPreFilledWidget(),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: 26 * 8,
                    child: Text(
                      _progressOrErrorText,
                      textAlign: TextAlign.start,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Theme.of(context).colorScheme.error),
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              child: const Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}
