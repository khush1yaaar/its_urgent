import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/core/views/widgets/elevated_button_with_icon.dart';
import 'package:its_urgent/src/features/auth/auth_controllers/phone_auth_controller.dart';
import 'package:its_urgent/src/features/auth/auth_views/auth_widgets/pinput_constants.dart';
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
  bool _isLoading = false;
  bool _isErrorText = false;

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
      _progressOrErrorText = "Verifying...";
      _isErrorText = false;
    });

    final result = await ref
        .read(phoneAuthController)
        .verifyOtp(widget.verificationId, _otpCode, widget.phoneNumber);

    setState(()  {
      _isLoading = false;
      if (result == true) {
          ref.read(currentUserPhoneController.notifier).updateCurrentUserPhone(
              widget.phoneNumber);
        _isErrorText = false;
        _progressOrErrorText = "Verification successful!";
      } else {
        _progressOrErrorText = result.toString();
        _isErrorText = true;
        focusNode.requestFocus();
      }
    });
  }

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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
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
                  Container(
                    width: 243,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Pinput(
                        onChanged: (value) {
                          setState(() {
                            _otpCode = value;
                          });
                        },
                        separatorBuilder: (index) => Container(
                          height: 64,
                          width: 1,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        focusedPinTheme: pinputPinTheme(context).copyWith(
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                        ),
                        autofocus: true,
                        focusNode: focusNode,
                        controller: controller,
                        length: 6,
                        defaultPinTheme: pinputPinTheme(context),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: 26 * 8,
                    child: Text(
                      _progressOrErrorText,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: _isLoading || !_isErrorText
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.error),
                    ),
                  )
                ],
              ),
            ),
            ElevatedButtonWithIcon(
              onPressed: _otpCode.length != 6 || _isLoading ? null : _verifyOtp,
              child: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    )
                  : const Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}
