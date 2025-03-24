// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MentorshipScreen extends StatelessWidget {
//   const MentorshipScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Mentorship Programs'),
//         centerTitle: true,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('mentorships').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return const Center(child: Text('Error loading mentorships.'));
//           }

//           final connections = snapshot.data!.docs;

//           if (connections.isEmpty) {
//             return const Center(child: Text('No mentorship programs available.'));
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: connections.length,
//             itemBuilder: (context, index) {
//               final connection = connections[index];
//               return MentorshipCard(connection: connection);
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class MentorshipCard extends StatelessWidget {
//   final QueryDocumentSnapshot connection;

//   const MentorshipCard({super.key, required this.connection});

//   @override
//   Widget build(BuildContext context) {
//     String mentorId = connection['mentorId'];
//     String menteeId = connection['menteeId'];
//     String mentorExpertise = connection['mentorExpertise'] ?? 'Expertise not specified';
//     String availability = connection['availability'] ?? 'Availability not specified';

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const CircleAvatar(
//                   backgroundColor: Colors.blueAccent,
//                   radius: 30,
//                   child: Icon(Icons.person, color: Colors.white, size: 30),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Text(
//                     'Mentor: $mentorId',
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Mentee: $menteeId',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               'Expertise: $mentorExpertise',
//               style: const TextStyle(color: Colors.grey),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               'Availability: $availability',
//               style: const TextStyle(color: Colors.grey),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: () {
//                 // Implement functionality to request mentorship or view details
//                 _showDetailDialog(context, mentorId, menteeId, mentorExpertise);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blueAccent, // Use backgroundColor instead of primary
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text('View Details'),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void _showDetailDialog(BuildContext context, String mentorId, String menteeId, String mentorExpertise) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Mentorship Details'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Mentor ID: $mentorId'),
//               Text('Mentee ID: $menteeId'),
//               Text('Expertise: $mentorExpertise'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Close'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Implement request mentorship functionality
//                 // For example, you can call a function to send a request to the mentor
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Request Mentorship'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MentorshipScreen extends StatelessWidget {
  const MentorshipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentorship Programs'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchMentorships(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading mentorships.'));
          }

          final connections = snapshot.data!;

          if (connections.isEmpty) {
            return const Center(child: Text('No mentorship programs available.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: connections.length,
            itemBuilder: (context, index) {
              final connection = connections[index];
              return MentorshipCard(connection: connection);
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchMentorships() async {
    final response = await Supabase.instance.client
        .from('mentorships')
        .select('*, mentor:mentorId(id, name), mentee:menteeId(id, name)')
        .execute();

    if (response.error != null) {
      throw Exception('Failed to fetch mentorships: ${response.error!.message}');
    }

    return response.data as List<Map<String, dynamic>>;
  }
}

extension on PostgrestFilterBuilder<PostgrestList> {
  execute() {}
}

class MentorshipCard extends StatelessWidget {
  final Map<String, dynamic> connection;

  const MentorshipCard({super.key, required this.connection});

  @override
  Widget build(BuildContext context) {
    String mentorName = connection['mentor']['name'] ?? 'Unknown Mentor';
    String menteeName = connection['mentee']['name'] ?? 'Unknown Mentee';
    String mentorExpertise = connection['mentorExpertise'] ?? 'Expertise not specified';
    String availability = connection['availability'] ?? 'Availability not specified';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  radius: 30,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Mentor: $mentorName',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Mentee: $menteeName',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              'Expertise: $mentorExpertise',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Availability: $availability',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                _showDetailDialog(context, mentorName, menteeName, mentorExpertise);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('View Details'),
            )
          ],
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, String mentorName, String menteeName, String mentorExpertise) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Mentorship Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Mentor: $mentorName'),
              Text('Mentee: $menteeName'),
              Text('Expertise: $mentorExpertise'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                // Implement request mentorship functionality
                Navigator.of(context).pop();
              },
              child: const Text('Request Mentorship'),
            ),
          ],
        );
      },
    );
  }
}