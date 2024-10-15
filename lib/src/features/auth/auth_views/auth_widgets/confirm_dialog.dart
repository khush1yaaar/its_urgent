import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:its_urgent/src/features/auth/auth_controllers/phone_auth_controller.dart';
import 'package:its_urgent/src/features/auth/auth_providers/selected_country_provider.dart';

class ConfirmDialog extends ConsumerStatefulWidget {
  const ConfirmDialog({
    super.key,
    required this.phoneCode,
    required this.phoneNumber,
    required this.isWrongNumberFormat,
  });

  final String phoneCode;
  final String phoneNumber;
  final bool isWrongNumberFormat;

  @override
  ConsumerState<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends ConsumerState<ConfirmDialog> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _confirmPhoneNumber() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(phoneAuthController).phoneAuthentication(
            context,
            widget.phoneCode,
            widget.phoneNumber.trim(),
          );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isWrongNumberFormat
        ? AlertDialog(
            title: Text(
              "Please again check your number!",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            content: Text(
              "The phone number you entered is either too short or is invalid for the country: ${ref.watch(selectedCountryProvider)!.name}.",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        : AlertDialog(
            title: _isLoading
                ? null
                : Text(
                    'Is this number correct?',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
            content: _isLoading
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Connecting...",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        const Expanded(child: SizedBox()),
                        const CircularProgressIndicator(),
                      ],
                    ),
                  )
                : _errorMessage != null
                    ? Text(_errorMessage!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onError))
                    : Text(
                        "${widget.phoneCode} ${widget.phoneNumber}",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
            actions: <Widget>[
              if (!_isLoading)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Edit'),
                ),
              if (!_isLoading)
                TextButton(
                  onPressed: _confirmPhoneNumber,
                  child: const Text('Confirm'),
                ),
            ],
          );
  }
}
