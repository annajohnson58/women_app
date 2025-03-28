import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:women_app/services/supabase_service.dart';
import 'package:women_app/services/notification_service.dart';
import 'package:women_app/providers/period_tracker_provider.dart';

import 'package:women_app/screens/login_page.dart';
import 'package:women_app/screens/registration_page.dart';
import 'package:women_app/screens/home/home_page.dart';
import 'package:women_app/screens/profile_page.dart';
import 'package:women_app/screens/emergency/user_profile_screen.dart';
import 'package:women_app/screens/EmergencySectionScreen.dart';
import 'package:women_app/screens/emergency/add_contact_screen.dart';
import 'package:women_app/screens/emergency/emergency_safety_screen.dart';
import 'package:women_app/screens/emergency/safety_tips_screen.dart';
import 'package:women_app/screens/career/career_development_screen.dart';
import 'package:women_app/screens/career/job_listings_screen.dart';
import 'package:women_app/screens/career/resume_builder_screen.dart';
import 'package:women_app/screens/career/skill_development_screen.dart';
import 'package:women_app/screens/career/mentorship_screen.dart';
import 'package:women_app/screens/career/webinars_screen.dart';
import 'package:women_app/screens/health_wellness/health_wellness_screen.dart';
import 'package:women_app/screens/health_wellness/period_tracker_screen.dart';
import 'package:women_app/screens/health_wellness/notification_settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(); // ✅ Load environment variables

  await Firebase.initializeApp(); // ✅ Initialize Firebase

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  await NotificationService.initialize(); // ✅ Initialize Notifications

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseService = SupabaseService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PeriodTrackerProvider()), // ✅ Add Period Tracker Provider
      ],
      child: MaterialApp(
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
          '/period_tracker': (context) => PeriodTrackerScreen(),
          '/notification_settings': (context) => NotificationSettingsScreen(),
        },
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
      ),
    );
  }
}
