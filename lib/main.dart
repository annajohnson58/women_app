import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:women_app/screens/login_page.dart';
import 'package:women_app/screens/registration_page.dart';
import 'package:women_app/screens/home/home_page.dart';
import 'package:women_app/screens/profile_page.dart';
import 'package:women_app/screens/emergency/user_profile_screen.dart';
import 'package:women_app/screens/EmergencySectionScreen.dart';
import 'package:women_app/screens/emergency/add_contact_screen.dart';
import 'package:women_app/screens/emergency/emergency_safety_screen.dart';
import 'package:women_app/screens/emergency/safety_tips_screen.dart';
import 'package:women_app/services/supabase_service.dart';
import 'package:women_app/screens/career/career_development_screen.dart';
import 'package:women_app/screens/career/job_listings_screen.dart';
import 'package:women_app/screens/career/resume_builder_screen.dart';
import 'package:women_app/screens/career/skill_development_screen.dart';
import 'package:women_app/screens/career/mentorship_screen.dart';
import 'package:women_app/screens/health_wellness/health_wellness_screen.dart';

import 'package:women_app/screens/career/webinars_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Supabase
  await Supabase.initialize(
    url: 'https://vohzpybcmnkvzdshqkuo.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZvaHpweWJjbW5rdnpkc2hxa3VvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI3MTA4NDMsImV4cCI6MjA1ODI4Njg0M30.0GqBOk4JOSSWvBGu-Uf6i6lWNWLVMEM5_K2c2xMumac',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseService = SupabaseService();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Women App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/emergency_section': (context) => EmergencySectionScreen(supabaseService: supabaseService),
        '/career_development': (context) => CareerDevelopmentScreen(),
        '/job_listings': (context) => JobListingsScreen(),
        '/resume_builder': (context) => ResumeBuilderScreen(),
        '/skill_development': (context) => SkillDevelopmentScreen(),
       '/mentorship': (context) => MentorshipScreen(),

        '/webinars': (context) => WebinarsScreen(),
        '/health_wellness': (context) => HealthWellnessScreen(),

      },
      // ✅ Handle dynamic routes
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/user_profile':
            final supabaseService = settings.arguments as SupabaseService?;
            if (supabaseService == null) throw Exception("SupabaseService required!");
            return MaterialPageRoute(
              builder: (context) => UserProfileScreen(supabaseService: supabaseService),
            );

          case '/add_contact':
            final supabaseService = settings.arguments as SupabaseService?;
            if (supabaseService == null) throw Exception("SupabaseService required!");
            return MaterialPageRoute(
              builder: (context) => AddContactScreen(supabaseService: supabaseService),
            );

          case '/emergency_safety':
            final supabaseService = settings.arguments as SupabaseService?;
            if (supabaseService == null) throw Exception("SupabaseService required!");
            return MaterialPageRoute(
              builder: (context) => EmergencySafetyScreen(supabaseService: supabaseService),
            );

          case '/safety_tips':
            final supabaseService = settings.arguments as SupabaseService?;
            if (supabaseService == null) throw Exception("SupabaseService required!");
            return MaterialPageRoute(
              builder: (context) => SafetyTipsScreen(supabaseService: supabaseService),
            );

          default:
            return null;
        }
      },
    );
  }
}
