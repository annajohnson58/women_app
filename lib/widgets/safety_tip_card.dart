import 'package:flutter/material.dart';

class SafetyTipCard extends StatelessWidget {
  final dynamic tip;

  const SafetyTipCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(tip['tip']),
      ),
    );
  }
}