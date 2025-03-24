import 'package:flutter/material.dart';


class CareerDevelopmentScreen extends StatelessWidget {
  const CareerDevelopmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Career Development"),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildCareerCard(context, "AI Job Matching", Icons.work, '/job_listings'),
            _buildCareerCard(context, "Resume Builder", Icons.article, '/resume_builder'),
            _buildCareerCard(context, "Skill Development", Icons.school, '/skill_development'),
            _buildCareerCard(context, "Mentorship", Icons.support, '/career_guidance'),
            _buildCareerCard(context, "Live Webinars", Icons.video_library, '/webinars'),
          ],
        ),
      ),
    );
  }

  Widget _buildCareerCard(BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.pink),
            SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
