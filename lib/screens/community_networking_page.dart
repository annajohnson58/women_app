// import 'package:flutter/material.dart';
// import 'community/forum_screen.dart'; // Ensure to import your ForumScreen
// import 'community/chat_screen.dart'; // Ensure to import your ChatScreen
// import 'community/mentorship_screen.dart'; // Ensure to import your MentorshipScreen

// class CommunityNetworkingScreen extends StatelessWidget {
//   const CommunityNetworkingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Community & Networking'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ForumScreen()),
//                 );
//               },
//               child: Text('Community Forum'),
//             ),
//             SizedBox(height: 20), // Adding spacing
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ChatScreen()),
//                 );
//               },
//               child: Text('Chat Groups'),
//             ),
//             SizedBox(height: 20), // Adding spacing
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => MentorshipScreen()),
//                 );
//               },
//               child: Text('Mentorship Programs'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }