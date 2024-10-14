import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:its_urgent/src/core/helpers/helper_methods.dart';
import 'package:its_urgent/src/core/routing/app_router.dart';
import 'package:its_urgent/src/features/auth/models/class_models/challenge.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen(
      {super.key,
      required this.name,
      required this.focusStatus,
      required this.senderUid,
      required this.receiverUid,
      required this.challenge});

  final String name;
  final int focusStatus;
  final String senderUid;
  final String receiverUid;
  final Challenge challenge;

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isButtonEnabled = false;
  String? errorText;

  void _checkInput() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        isButtonEnabled = true;
      } else {
        isButtonEnabled = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_checkInput);
    print('Sender Uid: ${widget.senderUid}');
  }

  @override
  void dispose() {
    _controller.removeListener(_checkInput);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("DND MODE Challenge"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  '${widget.name} is in DND mode. Answer the following challenge to send the notification.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.challenge.question,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Answer',
                    errorText: errorText,
                  ),
                  keyboardType: widget.challenge.answerType == 'number'
                      ? TextInputType.number
                      : TextInputType.text,
                  enableInteractiveSelection: false,
                  enableSuggestions: false,
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text("Answer Type: ${widget.challenge.answerType}"),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () async {
                          if (_controller.text.toLowerCase() !=
                              widget.challenge.answer.toLowerCase()) {
                            setState(() {
                              errorText = 'Incorrect Answer';
                            });
                            return;
                          }
                          Navigator.of(context).pop();

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
        ),
      ),
    );
  }
}
