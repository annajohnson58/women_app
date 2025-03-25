import 'package:flutter/material.dart';
import 'tracker_screen.dart';
import 'workout_screen.dart';
import 'diet_screen.dart';
import 'mental_wellness_screen.dart';
import 'period_tracker_screen.dart';
import 'notification_settings_screen.dart';

class HealthWellnessScreen extends StatelessWidget {
  const HealthWellnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health & Wellness"),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationSettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          _buildFeatureCard(context, "Health Tracker", Icons.track_changes, TrackerScreen()),
          _buildFeatureCard(context, "Workouts & Yoga", Icons.fitness_center, WorkoutScreen()),
          _buildFeatureCard(context, "Diet & Nutrition", Icons.restaurant, DietScreen()),
          _buildFeatureCard(context, "Mental Wellness", Icons.self_improvement, MentalWellnessScreen()),
          _buildFeatureCard(context, "Period Tracker", Icons.calendar_today, PeriodTrackerScreen()),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Widget screen) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.pink),
            SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
