import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:its_urgent/constants/default_profile_image.dart';
import 'package:its_urgent/providers/cloud_firestore_provider.dart';
import 'package:its_urgent/providers/firebase_auth_provider.dart';
import 'package:its_urgent/providers/firebase_storeage_provider.dart';
import 'package:its_urgent/providers/its_urgent_user_provider.dart';
import 'package:its_urgent/routing/app_router.dart';

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

      // Get the FirebaseStorageRepo and CloudFirestoreRepo from Riverpod
      final firebaseStorageRepo = ref.read(firebaseStorageProvider);
      final cloudFirestoreRepo = ref.read(cloudFirestoreProvider);

      String imageUrl;
      // Step 1: if no image is selected directly uses the link of ui avatar, no need to upload it to the firebase storage.
      if (_imageFile != null) {
        imageUrl =
            await firebaseStorageRepo.getImageUrl(uid, File(_imageFile!.path));
      } else {
        if (_currentUserImageUrl != null) {
          imageUrl = _currentUserImageUrl!;
        } else {
          imageUrl = kimageURL;
        }
      }

      // Step 2: Add or update the user data in Firestore
      await cloudFirestoreRepo.addUser(
          uid: uid, name: _nameString, imageUrl: imageUrl);

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
    final currentUser = ref.read(itsUrgentUserProvider);
    if (currentUser != null) {
      _nameString = currentUser.name;
      _nameController.text = _nameString;
      _currentUserImageUrl = currentUser.imageUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Info"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              // to make sure that view does not overflow on any screen.
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Please provide your name and an optional profile photo",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
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
                    if (_imageFile != null)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _imageFile = null;
                          });
                        },
                        style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.error),
                        child: const Text(
                          "Remove Image",
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            _pickImage(ImageSource.camera);
                          },
                          child: const Text("Image from Camera"),
                        ),
                        TextButton(
                          onPressed: () {
                            _pickImage(ImageSource.gallery);
                          },
                          child: const Text("Image from Gallery"),
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
                      decoration: InputDecoration(
                          hintText: "Name", errorText: _errorText),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (_uploadErrorText != null)
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          _uploadErrorText!,
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: _isErrorUploading
                                      ? Theme.of(context).colorScheme.error
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                        ),
                      )
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _nameString.length < 2
                  ? null
                  : () {
                      _updateProfile(context);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
