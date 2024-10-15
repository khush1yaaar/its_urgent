// Challenge Setup Dialog
import 'package:flutter/material.dart';
import 'package:its_urgent/src/core/views/widgets/elevated_button_with_icon.dart';
import 'package:its_urgent/src/features/auth/models/class_models/challenge.dart';

class ChallengeSetupDialog extends StatefulWidget {
  const ChallengeSetupDialog({super.key, required this.challenge});
  final Challenge challenge;

  @override
  State<ChallengeSetupDialog> createState() => _ChallengeSetupDialogState();
}

class _ChallengeSetupDialogState extends State<ChallengeSetupDialog> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  String _selectedAnswerType = 'mixed'; // Default selection: mixed characters
  bool _isSubmitEnabled = false; // Track if the submit button should be enabled

  @override
  void initState() {
    super.initState();
    _questionController.text = widget.challenge.question;
    _answerController.text = widget.challenge.answer;
    _selectedAnswerType = widget.challenge.answerType;

    _questionController.addListener(_updateSubmitButtonState);
    _answerController.addListener(_updateSubmitButtonState);
    _updateSubmitButtonState();
  }

  void _updateSubmitButtonState() {
    setState(() {
      _isSubmitEnabled = _questionController.text.trim().isNotEmpty &&
          _answerController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _questionController.removeListener(_updateSubmitButtonState);
    _answerController.removeListener(_updateSubmitButtonState);
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Challenge Setup'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without result
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Add a challenge for your contacts to solve before they can reach you in DND mode.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _questionController,
                  maxLines: 3,
                  minLines: 2,
                  scrollController: ScrollController(),
                  decoration: const InputDecoration(
                    labelText: 'Challenge question',
                    hintText: 'E.g., Solve this math problem...',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _answerController,
                  decoration: const InputDecoration(
                    labelText: 'Answer (case-insensitive)',
                    hintText: 'E.g., 42 or forty-two',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select answer type:',
                  style: TextStyle(fontSize: 16),
                ),
                RadioListTile<String>(
                  title: const Text('All numbers'),
                  value: 'numbers',
                  groupValue: _selectedAnswerType,
                  onChanged: (value) {
                    setState(() {
                      _selectedAnswerType = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Mixed characters'),
                  value: 'mixed',
                  groupValue: _selectedAnswerType,
                  onChanged: (value) {
                    setState(() {
                      _selectedAnswerType = value!;
                    });
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButtonWithIcon(
                    onPressed: _isSubmitEnabled
                        ? () async {
                            Navigator.of(context).pop({
                              'question': _questionController.text.trim(),
                              'answer': _answerController.text.trim(),
                              'answerType': _selectedAnswerType,
                            });
                          }
                        : null,
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
