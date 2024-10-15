import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:its_urgent/src/core/controllers/cloud_firestore_controller.dart';
import 'package:its_urgent/src/core/controllers/firebase_storage_controller.dart';
import 'package:its_urgent/src/core/models/its_urgent_user.dart';
import 'package:its_urgent/src/core/views/widgets/elevated_button_with_icon.dart';
import 'package:its_urgent/src/features/auth/auth_controllers/phone_auth_controller.dart';
import 'package:its_urgent/src/features/auth/auth_views/auth_widgets/challenge_setup_dialog.dart';
import 'package:its_urgent/src/features/auth/models/class_models/challenge.dart';
import 'package:its_urgent/src/features/auth/models/data_constants/default_profile_image.dart';

import 'package:its_urgent/src/core/controllers/firebase_auth_controller.dart';

import 'package:its_urgent/src/core/controllers/its_urgent_user_controller.dart';
import 'package:its_urgent/src/core/routing/app_router.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _nameString = "";
  String? _errorText;
  String? _uploadErrorText;
  XFile? _imageFile;
  bool _isErrorUploading = false;
  String? _currentUserImageUrl;
  Challenge? _challenge;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    if (selectedImage != null) {
      setState(() {
        _imageFile = selectedImage;
      });
    }
  }

  void _updateProfile(BuildContext context) async {
    try {
      setState(() {
        _uploadErrorText = "Uploading data...";
        _isErrorUploading = false;
      });
      // Replace this with the actual UID of the user
      final String uid = ref.read(firebaseAuthProvider).currentUser!.uid;

      // Get the FirebaseStorageController and CloudFirestoreController from Riverpod
      final firebaseStorage = ref.read(firebaseStorageController);
      final cloudFirestore = ref.read(cloudFirestoreController);

      String imageUrl;
      // Step 1: if no image is selected directly uses the link of ui avatar, no need to upload it to the firebase storage.
      if (_imageFile != null) {
        imageUrl =
            await firebaseStorage.getImageUrl(uid, File(_imageFile!.path));
      } else {
        if (_currentUserImageUrl != null) {
          imageUrl = _currentUserImageUrl!;
        } else {
          imageUrl = kimageURL;
        }
      }

      // Step 2: Add or update the user data in Firestore
      await cloudFirestore.addUser(
          uid: uid,
          name: _nameString,
          imageUrl: imageUrl,
          challenge: _challenge!);

      // Step 3: Update the user data in the app state
      ref.read(itsUrgentUserController.notifier).updateUserDetails({
        UserDocFields.name.name: _nameString,
        UserDocFields.imageUrl.name: imageUrl,
        UserDocFields.uid.name: uid,
      });

      setState(() {
        _uploadErrorText = "Profile Updated successfully";
        _isErrorUploading = false;
      });
      if (context.mounted) {
        context.goNamed(AppRoutes.homeScreen.name);
      }
    } catch (e) {
      setState(() {
        _uploadErrorText = e.toString();
        _isErrorUploading = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch the current user's name and set it as the initial value of the controller
    final currentUser = ref.read(itsUrgentUserController);
    if (currentUser != null) {
      _nameString = currentUser.name;
      _nameController.text = _nameString;
      _currentUserImageUrl = currentUser.imageUrl;
      _challenge = Challenge(
          question: currentUser.question,
          answer: currentUser.answer,
          answerType: currentUser.answerType);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _showChallengeSetupDialog(BuildContext context) async {
    final result = await showDialog<Map<String, String>>(
        context: context,
        builder: (BuildContext context) {
          return ChallengeSetupDialog(
            challenge: _challenge ??
                Challenge(question: "", answer: "", answerType: "mixed"),
          ); // Your dialog widget
        },
        useRootNavigator: false);

    // Check if the result is not null and process it
    if (result != null) {
      final question = result['question'];
      final answer = result['answer'];
      final answerType = result['answerType'];

      setState(() {
        _challenge = Challenge(
            question: question!, answer: answer!, answerType: answerType!);
      });

      // Use the values as needed
      print('Question: $question');
      print('Answer: $answer');
      print('Answer Type: $answerType');

      // You can handle these values as needed (e.g., store them, show them, etc.)
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (context, ref, _) {
          final currentPhone = ref.watch(currentUserPhoneController);
          return Text("Profile Info (${currentPhone.value})");
        }),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Please provide your name and an optional profile photo",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(
                height: 28,
              ),
              CircleAvatar(
                maxRadius: size.width * 0.25,
                backgroundColor: _nameString.isEmpty
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Colors.transparent,
                backgroundImage: _currentUserImageUrl != null
                    ? NetworkImage(_currentUserImageUrl!)
                    : const AssetImage("assets/profile.jpg"),
                foregroundImage: _imageFile != null
                    ? FileImage(File(_imageFile!.path))
                    : null,
                child: _nameString.isEmpty
                    ? Icon(
                        Icons.add_a_photo_rounded,
                        size: size.width * 0.25,
                      )
                    : null,
              ),
              const SizedBox(
                height: 20,
              ),
              if (_imageFile != null)
                TextButton.icon(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _imageFile = null;
                    });
                  },
                  style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error),
                  label: const Text(
                    "Remove Image",
                  ),
                ),
              Row(
                children: [
                  TextButton.icon(
                    icon: Icon(
                      Icons.add_a_photo,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                    label: Text(
                      "Camera Image",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                            decorationColor:
                                Theme.of(context).colorScheme.secondary,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                  TextButton.icon(
                    icon: Icon(
                      Icons.photo,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                    label: Text(
                      "Gallery Image",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                            decorationColor:
                                Theme.of(context).colorScheme.secondary,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _nameController,
                maxLength: 25,
                onChanged: (value) {
                  setState(() {
                    _nameString = value;
                    if (_nameString.length >= 2) {
                      _errorText = null;
                    } else {
                      _errorText =
                          "Minimum 2 characters must be provided for the name";
                    }
                  });
                },
                decoration:
                    InputDecoration(hintText: "Name", errorText: _errorText),
              ),
              const SizedBox(
                height: 16,
              ),
              if (_uploadErrorText != null)
                SizedBox(
                  width: double.infinity,
                  height: 28,
                  child: Text(
                    _uploadErrorText!,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: _isErrorUploading
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ListTile(
                tileColor: _challenge == null
                    ? Theme.of(context)
                        .colorScheme
                        .errorContainer
                        .withOpacity(0.5)
                    : null,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: _challenge == null
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                      width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: const Icon(
                  Icons.security,
                ),
                title: Text(
                  _challenge != null
                      ? "Modify challenge here"
                      : "Setup challenge here",
                ),
                subtitle: Text(
                  _challenge != null ? "Status: Set." : "Status: Not set.",
                ),
                onTap: () {
                  _showChallengeSetupDialog(context);
                },
                trailing: _challenge == null
                    ? const Icon(Icons.warning)
                    : const Icon(Icons.check),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButtonWithIcon(
                  onPressed: _nameString.length < 2 || _challenge == null
                      ? null
                      : () {
                          _updateProfile(context);
                        },
                  child: const Text("Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
