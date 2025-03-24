// // // // import 'package:flutter/material.dart';
// // // // import 'package:firebase_auth/firebase_auth.dart';

// // // // class HomePage extends StatelessWidget {
// // // //   final FirebaseAuth _auth = FirebaseAuth.instance;

// // // //   HomePage({super.key});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Text('Home'),
// // // //         actions: [
// // // //           IconButton(
// // // //             icon: Icon(Icons.logout),
// // // //             onPressed: () async {
// // // //               await _auth.signOut();
// // // //               // ignore: use_build_context_synchronously
// // // //               Navigator.pushReplacementNamed(context, '/'); // Navigate to login page
// // // //             },
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       // Wrap the body in a SingleChildScrollView
// // // //       body: SingleChildScrollView(
// // // //         child: Center(
// // // //           child: Column(
// // // //             mainAxisAlignment: MainAxisAlignment.center,
// // // //             children: [
// // // //               Text(
// // // //                 'Welcome to Women App!',
// // // //                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// // // //               ),
// // // //               SizedBox(height: 20),
// // // //               ElevatedButton(
// // // //                 onPressed: () {
// // // //                   Navigator.pushNamed(context, '/profile'); // Navigate to profile page
// // // //                 },
// // // //                 child: Text('Go to Profile'),
// // // //               ),
// // // //               SizedBox(height: 20), // Adding some spacing
// // // //               ElevatedButton(
// // // //                 onPressed: () {
// // // //                   Navigator.pushNamed(context, '/communityNetworking'); // Navigate to community and networking page
// // // //                 },
// // // //                 child: Text('Community & Networking'),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // import 'package:flutter/material.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'community/forum_screen.dart';
// // // import 'community/chat_screen.dart';
// // // import 'community/mentorship_screen.dart';

// // // class HomePage extends StatefulWidget {
// // //   const HomePage({super.key});

// // //   @override
// // //   // ignore: library_private_types_in_public_api
// // //   _HomePageState createState() => _HomePageState();
// // // }

// // // class _HomePageState extends State<HomePage> {
// // //   final FirebaseAuth _auth = FirebaseAuth.instance;

// // //   // Index to track the currently selected tab
// // //   int _selectedIndex = 0;

// // //   // List of screens for bottom navigation
// // //   final List<Widget> _screens = [
// // //     ForumScreen(), // Screen for Forums
// // //     ChatScreen(), // Screen for Chat
// // //     MentorshipScreen(), // Screen for Mentorship
// // //   ];

// // //   void _onItemTapped(int index) {
// // //     setState(() {
// // //       _selectedIndex = index; // Update selected index
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Home'),
// // //         leading: IconButton(
// // //           icon: Icon(Icons.person),
// // //           onPressed: () {
// // //             Navigator.pushNamed(context, '/profile'); // Navigate to profile page
// // //           },
// // //         ),
// // //         actions: [
// // //           IconButton(
// // //             icon: Icon(Icons.logout),
// // //             onPressed: () async {
// // //               await _auth.signOut();
// // //               // ignore: use_build_context_synchronously
// // //               Navigator.pushReplacementNamed(context, '/'); // Navigate to login page
// // //             },
// // //           ),
// // //         ],
// // //       ),
// // //       body: _screens[_selectedIndex], // Display the currently selected screen
// // //       bottomNavigationBar: BottomNavigationBar(
// // //         items: const <BottomNavigationBarItem>[
// // //           BottomNavigationBarItem(
// // //             icon: Icon(Icons.forum),
// // //             label: 'Forums',
// // //           ),
// // //           BottomNavigationBarItem(
// // //             icon: Icon(Icons.chat),
// // //             label: 'Chat',
// // //           ),
// // //           BottomNavigationBarItem(
// // //             icon: Icon(Icons.person_add_alt),
// // //             label: 'Mentorship',
// // //           ),
// // //         ],
// // //         currentIndex: _selectedIndex, // Highlight the selected tab
// // //         selectedItemColor: Colors.blue,
// // //         onTap: _onItemTapped, // Handle tab changes
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'community/chat_screen.dart';
// // import 'community/forum_screen.dart';
// // import 'community/mentorship_screen.dart';

// // class HomePage extends StatefulWidget {
// //   const HomePage({super.key});

// //   @override
// //   // ignore: library_private_types_in_public_api
// //   _HomePageState createState() => _HomePageState();
// // }

// // class _HomePageState extends State<HomePage> {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;

// //   // Index to track the currently selected tab
// //   int _selectedIndex = 0;

// //   // List of screens for bottom navigation
// //   final List<Widget> _screens = [
// //     HomeScreen(), // Screen for Home
// //     ForumScreen(), // Screen for Forums
// //     ChatScreen(), // Screen for Chat
// //     MentorshipScreen(), // Screen for Mentorship
// //   ];

// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index; // Update selected index
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Home'),
// //         leading: IconButton(
// //           icon: Icon(Icons.person),
// //           onPressed: () {
// //             Navigator.pushNamed(context, '/profile'); // Navigate to profile page
// //           },
// //         ),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.logout),
// //             onPressed: () async {
// //               await _auth.signOut();
// //               // ignore: use_build_context_synchronously
// //               Navigator.pushReplacementNamed(context, '/'); // Navigate to login page
// //             },
// //           ),
// //         ],
// //       ),
// //       body: _screens[_selectedIndex], // Display the currently selected screen
// //       bottomNavigationBar: BottomNavigationBar(
// //         items: const <BottomNavigationBarItem>[
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.home), // Home icon
// //             label: 'Home',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.forum),
// //             label: 'Forums',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.chat),
// //             label: 'Chat',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.person_add_alt),
// //             label: 'Mentorship',
// //           ),
// //         ],
// //         currentIndex: _selectedIndex, // Highlight the selected tab
// //         selectedItemColor: Colors.blue, // Color for the selected tab icon
// //         unselectedItemColor: Colors.grey, // Color for unselected tab icons
// //         backgroundColor: Colors.white, // Background color of the bottom bar
// //         onTap: _onItemTapped, // Handle tab changes
// //       ),
// //     );
// //   }
// // }

// // // Home Screen Widget with Sections
// // class HomeScreen extends StatelessWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(16.0),
// //       child: Column(
// //         children: [
// //           Text(
// //             'Welcome to Women App!',
// //             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //           ),
// //           SizedBox(height: 20),
// //           // Section for Health and Wellness
// //           SectionCard(
// //             title: 'Health & Wellness',
// //             subtitle: 'Track your health and fitness',
// //             icon: Icons.health_and_safety,
// //             onTap: () {
// //               Navigator.pushNamed(context, '/healthAndWellness'); // Navigate to Health and Wellness module
// //             },
// //           ),
// //           SizedBox(height: 16),
// //           // Section for Career Development
// //           SectionCard(
// //             title: 'Career Development',
// //             subtitle: 'Articles and resources for your career',
// //             icon: Icons.business_center,
// //             onTap: () {
// //               Navigator.pushNamed(context, '/career_development'); // Navigate to Career Development module
// //             },
// //           ),
// //           SizedBox(height: 16),
// //           // Section for Emergency Safety
// //           SectionCard(
// //             title: 'Emergency Safety',
// //             subtitle: 'Resources for safety and emergency',
// //             icon: Icons.security,
// //             onTap: () {
// //               Navigator.pushNamed(context, '/emergencySafety'); // Navigate to Emergency Safety module
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // SectionCard Widget
// // class SectionCard extends StatelessWidget {
// //   final String title;
// //   final String subtitle;
// //   final IconData icon;
// //   final VoidCallback onTap;

// //   const SectionCard({
// //     super.key,
// //     required this.title,
// //     required this.subtitle,
// //     required this.icon,
// //     required this.onTap,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Card(
// //         elevation: 4,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Row(
// //             children: [
// //               Icon(icon, size: 40, color: Colors.blue),
// //               SizedBox(width: 16),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// //                     SizedBox(height: 4),
// //                     Text(subtitle, style: TextStyle(color: Colors.grey)),
// //                   ],
// //                 ),
// //               ),
// //               Icon(Icons.arrow_forward_ios, color: Colors.grey),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }




// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../community/chat_screen.dart';
// import '../community/forum_screen.dart';
// import '../community/mentorship_screen.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final SupabaseClient _client = Supabase.instance.client;

//   // Index to track the currently selected tab
//   int _selectedIndex = 0;

//   // List of screens for bottom navigation
//   final List<Widget> _screens = [
//     HomeScreen(), // Screen for Home
//     ForumScreen(), // Screen for Forums
//     ChatScreen(), // Screen for Chat
//     MentorshipScreen(), // Screen for Mentorship
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index; // Update selected index
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//         leading: IconButton(
//           icon: Icon(Icons.person),
//           onPressed: () {
//             Navigator.pushNamed(context, '/profile'); // Navigate to profile page
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await _client.auth.signOut();
//               Navigator.pushReplacementNamed(context, '/'); // Navigate to login page
//             },
//           ),
//         ],
//       ),
//       body: _screens[_selectedIndex], // Display the currently selected screen
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home), // Home icon
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.forum),
//             label: 'Forums',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat),
//             label: 'Chat',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_add_alt),
//             label: 'Mentorship',
//           ),
//         ],
//         currentIndex: _selectedIndex, // Highlight the selected tab
//         selectedItemColor: Colors.blue, // Color for the selected tab icon
//         unselectedItemColor: Colors.grey, // Color for unselected tab icons
//         backgroundColor: Colors.white, // Background color of the bottom bar
//         onTap: _onItemTapped, // Handle tab changes
//       ),
//     );
//   }
// }

// // Home Screen Widget with Sections
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Text(
//             'Welcome to Women App!',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20),
//           // Section for Health and Wellness
//           SectionCard(
//             title: 'Health & Wellness',
//             subtitle: 'Track your health and fitness',
//             icon: Icons.health_and_safety,
//             onTap: () {
//               Navigator.pushNamed(context, '/health_wellness'); // Navigate to Health and Wellness module
//             },
//           ),
//           SizedBox(height: 16),
//           // Section for Career Development
//           SectionCard(
//             title: 'Career Development',
//             subtitle: 'Articles and resources for your career',
//             icon: Icons.business_center,
//             onTap: () {
//               Navigator.pushNamed(context, '/career_development'); // Navigate to Career Development module
//             },
//           ),
//           SizedBox(height: 16),
//           // Section for Emergency Safety
//           SectionCard(
//             title: 'Emergency Safety',
//             subtitle: 'Resources for safety and emergency',
//             icon: Icons.security,
//             onTap: () {
//               Navigator.pushNamed(context, '/emergency_section'); // Navigate to Emergency Safety module
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// // SectionCard Widget
// class SectionCard extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final VoidCallback onTap;

//   const SectionCard({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Icon(icon, size: 40, color: Colors.blue),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 4),
//                     Text(subtitle, style: TextStyle(color: Colors.grey)),
//                   ],
//                 ),
//               ),
//               Icon(Icons.arrow_forward_ios, color: Colors.grey),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:women_app/screens/community/forum_screen.dart';
import 'package:women_app/screens/community/chat_screen.dart';
import 'package:women_app/screens/community/mentorship_screen.dart';
import 'package:women_app/screens/home/home_dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SupabaseClient _client = Supabase.instance.client;
  int _selectedIndex = 0;

  // Screens for Bottom Navigation
  final List<Widget> _screens = [
    HomeDashboard(), // Updated Home Dashboard
    ForumScreen(),   // Community Forum
    ChatScreen(),    // Chat Section
    MentorshipScreen(), // Mentorship
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Women’s Hub '),
        backgroundColor: Colors.pink,
        leading: IconButton(
          icon: Icon(Icons.person, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, '/profile'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await _client.auth.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex], // Selected Screen
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_add_alt), label: 'Mentorship'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
