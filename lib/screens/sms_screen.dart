import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/providers/firebase_auth_provider.dart';
import 'package:its_urgent/widgets/pinput_constants.dart';
import 'package:pinput/pinput.dart';

class SmsScreen extends ConsumerStatefulWidget {
  const SmsScreen(
      {super.key, required this.phoneNumber, required this.verificationId});
  final String phoneNumber;
  final String verificationId;

  @override
  ConsumerState<SmsScreen> createState() => _SmsScreenState();
}

class _SmsScreenState extends ConsumerState<SmsScreen> {
  String _progressOrErrorText = "";
  String _otpCode = "";
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
    print(widget.verificationId);
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
                    
                    onChanged: (value) {
                      setState(() {
                        _otpCode = value;
                      });
                    },
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
              onPressed: _otpCode.length != 6
                  ? null
                  : () {
                      ref
                          .read(phoneAuthProvider)
                          .verifyOtp(widget.verificationId, _otpCode);
                    },
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
