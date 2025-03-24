import 'package:flutter/material.dart';

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Email Confirmation')),
      body: Center(
        child: Text(
          'Thank you for confirming your email! You can now log in.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}