import 'package:flutter/material.dart';

class EmergencyButton extends StatelessWidget {
  const EmergencyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
      ),
      onPressed: () {
        // TODO: Trigger emergency call or alert
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("🚨 Emergency Alert Sent!"))
        );
      },
      icon: Icon(Icons.sos),
      label: Text("Emergency Alert", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
