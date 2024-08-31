import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        title: const Text("404 Route doesn't exist"),
      ),
      body: const Center(
        child: Text("Routing Error Occured"),
      ),
    );
  }
}
