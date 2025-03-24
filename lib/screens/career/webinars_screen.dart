import 'package:flutter/material.dart';

class WebinarsScreen extends StatelessWidget {
  const WebinarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Career Webinars"), backgroundColor: Colors.pink),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildWebinarCard("Women in Tech", "Google", "Jan 15"),
          _buildWebinarCard("Starting a Business", "Startup Women", "Feb 10"),
        ],
      ),
    );
  }

  Widget _buildWebinarCard(String title, String host, String date) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Hosted by $host • $date"),
        trailing: Icon(Icons.play_circle_fill, color: Colors.pink),
      ),
    );
  }
}
