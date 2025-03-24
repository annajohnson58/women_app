import 'package:flutter/material.dart';

class SkillDevelopmentScreen extends StatelessWidget {
  const SkillDevelopmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Skill Development"), backgroundColor: Colors.pink),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildCourseCard("Data Science", "Coursera", "https://www.coursera.org"),
          _buildCourseCard("Digital Marketing", "Udemy", "https://www.udemy.com"),
          _buildCourseCard("Graphic Design", "Skillshare", "https://www.skillshare.com"),
        ],
      ),
    );
  }

  Widget _buildCourseCard(String title, String platform, String link) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(platform),
        trailing: IconButton(
          icon: Icon(Icons.open_in_new, color: Colors.pink),
          onPressed: () {
            // Open course link
          },
        ),
      ),
    );
  }
}
