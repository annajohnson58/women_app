import 'package:flutter/material.dart';
import 'package:women_app/screens/home/section_card.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 👋 Personalized Greeting
          _buildGreetingCard(),

          SizedBox(height: 20),

          // 🔹 Sections for Different Features
          SectionCard(
            title: ' Health & Wellness',
            subtitle: 'Track your health, fitness & wellness',
            icon: Icons.health_and_safety,
            onTap: () => Navigator.pushNamed(context, '/health_wellness'),
          ),
          SizedBox(height: 16),

          SectionCard(
            title: ' Career Development',
            subtitle: 'Find jobs, mentorship & skill growth',
            icon: Icons.business_center,
            onTap: () => Navigator.pushNamed(context, '/career_development'),
          ),
          SizedBox(height: 16),

          SectionCard(
            title: ' Emergency Safety',
            subtitle: 'Safety resources & emergency contacts',
            icon: Icons.security,
            onTap: () => Navigator.pushNamed(context, '/emergency_section'),
          ),
          SizedBox(height: 16),

          SectionCard(
            title: ' Community & Networking',
            subtitle: 'Join forums, chat & find mentors',
            icon: Icons.groups,
            onTap: () => Navigator.pushNamed(context, '/community'),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.pink.shade100,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/user_avatar.png'),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello, User! 👋",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text("Stay empowered, stay inspired!", style: TextStyle(color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
