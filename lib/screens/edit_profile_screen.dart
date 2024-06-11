import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _nameString = "";
  String? _errorText;
  XFile? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    if (selectedImage != null) {
      setState(() {
        _imageFile = selectedImage;
      });
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
                      backgroundImage: _nameString.isEmpty || _imageFile != null
                          ? null
                          : NetworkImage(
                              "https://ui-avatars.com/api/?name=${_nameString}&background=random&size=256"),
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
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _nameString.length < 2 ? null : () {},
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
