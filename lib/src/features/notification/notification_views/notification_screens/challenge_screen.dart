import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/src/core/helpers/helper_methods.dart';
import 'package:its_urgent/src/core/routing/app_router.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key, required this.name, required this.focusStatus, required this.senderUid, required this.receiverUid});

  final String name;
  final int focusStatus;
  final String senderUid;
  final String receiverUid;

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isButtonEnabled = false;
  String? errorText;

  void _checkInput() {
    setState(() {
      if (_controller.text == '000') {
        isButtonEnabled = true;
        errorText = null;
      } else {
        isButtonEnabled = false;
        errorText = 'Please type 000 to proceed.';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_checkInput);
  }

  @override
  void dispose() {
    _controller.removeListener(_checkInput);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DND MODE Challenge"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        child: Column(
          children: <Widget>[
            Text(
              '${widget.name} is in DND mode. Complete the challenge below to bypass & send the notification again.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Type 000',
                errorText: errorText,
              ),
              keyboardType: TextInputType.number,
              maxLength: 3,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              enableInteractiveSelection: false,
              enableSuggestions: false,
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: isButtonEnabled
                  ? () async {
                    context.goNamed(AppRoutes.homeScreen.name);

                      // Code to send the notification
                      await sendFocusStatusToCloudFunction(
                          focusStatus: widget.focusStatus,
                          senderUid: widget.senderUid,
                          receiverUid: widget.receiverUid,
                          bypass: true);
                    }
                  : null,
              child: const Text('Send Notification'),
            ),
            Text("Sender Uid: ${widget.senderUid}"),
            Text("Receiver Uid: ${widget.receiverUid}"),

          ],
        ),
      ),
      
    );
  }
}
