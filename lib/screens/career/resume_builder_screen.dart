import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:women_app/services/supabase_service.dart';

class ResumeBuilderScreen extends StatefulWidget {
  const ResumeBuilderScreen({super.key});

  @override
  ResumeBuilderScreenState createState() => ResumeBuilderScreenState();
}

class ResumeBuilderScreenState extends State<ResumeBuilderScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  bool _isLoading = false;

  Future<void> _uploadResume() async {
    setState(() => _isLoading = true);

    try {
      String userId = Supabase.instance.client.auth.currentUser!.id;
      List<String> skills = _skillsController.text.split(',');

      await _supabaseService.uploadResume(
        userId,
        "https://example.com/resume.pdf", // Replace with actual resume URL
        _nameController.text,
        skills,
        _experienceController.text,
      );

      if (!mounted) return; // ✅ Fix context issue
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Resume Uploaded!")));
    } catch (e) {
      if (!mounted) return; // ✅ Fix context issue
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Resume Builder"), backgroundColor: Colors.pink),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Full Name")),
            TextField(controller: _skillsController, decoration: InputDecoration(labelText: "Skills (comma separated)")),
            TextField(controller: _experienceController, decoration: InputDecoration(labelText: "Experience")),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _uploadResume,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Upload Resume"),
                  ),
          ],
        ),
      ),
    );
  }
}

extension on SupabaseService {
  uploadResume(String userId, String s, String text, List<String> skills, String text2) {}
}
