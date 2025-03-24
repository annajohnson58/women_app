import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:women_app/services/supabase_service.dart';

class MentorshipScreen extends StatefulWidget {
  const MentorshipScreen({super.key});

  @override
  _MentorshipScreenState createState() => _MentorshipScreenState();
}

class _MentorshipScreenState extends State<MentorshipScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<Map<String, dynamic>> mentors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMentors();
  }

  Future<void> _loadMentors() async {
    try {
      final fetchedMentors = await _supabaseService.getMentors();
      setState(() {
        mentors = fetchedMentors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mentorship Program"), backgroundColor: Colors.pink),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: mentors.length,
              itemBuilder: (context, index) {
                var mentor = mentors[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(Icons.person, color: Colors.pink, size: 40),
                    title: Text(mentor['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Expertise: ${mentor['expertise']}\nAvailability: ${mentor['availability']}"),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        _applyForMentorship(mentor['id']);
                      },
                      child: Text("Apply"),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _applyForMentorship(String mentorId) async {
    try {
      String userId = Supabase.instance.client.auth.currentUser!.id;
      await _supabaseService.applyForMentorship(userId, mentorId);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Application Sent!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
}

extension on SupabaseService {
  applyForMentorship(String userId, String mentorId) {}
  
  getMentors() {}
}
