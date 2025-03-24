import 'package:flutter/material.dart';
import 'package:women_app/services/supabase_service.dart';

class EmergencySectionScreen extends StatelessWidget {
  final SupabaseService supabaseService;

  const EmergencySectionScreen({super.key, required this.supabaseService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text('Emergency Section'),
        backgroundColor: Colors.pink.shade400,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildEmergencyCard(
              context,
              title: "User Profile",
              icon: Icons.person,
              route: '/user_profile',
            ),
            _buildEmergencyCard(
              context,
              title: "Safety Tips",
              icon: Icons.security,
              route: '/safety_tips',
            ),
            _buildEmergencyCard(
              context,
              title: "Emergency Safety",
              icon: Icons.local_police,
              route: '/emergency_safety',
            ),
            _buildEmergencyCard(
              context,
              title: "Add Emergency Contact",
              icon: Icons.contacts,
              route: '/add_contact',
            ),
          ],
        ),
      ),

      // 🚨 Floating Action Button for Quick Emergency Call
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        icon: Icon(Icons.sos, color: Colors.white),
        label: Text("Emergency Alert", style: TextStyle(color: Colors.white)),
        onPressed: () {
          // TODO: Implement emergency alert function
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("🚨 Emergency Alert Sent!")),
          );
        },
      ),
    );
  }

  Widget _buildEmergencyCard(BuildContext context,
      {required String title, required IconData icon, required String route}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route, arguments: supabaseService),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        color: Colors.pink.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.pink.shade800),
            SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
