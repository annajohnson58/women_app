import 'package:flutter/material.dart';
import 'package:women_app/services/supabase_service.dart';

class JobListingsScreen extends StatefulWidget {
  const JobListingsScreen({super.key});

  @override
  JobListingsScreenState createState() => JobListingsScreenState();
}

class JobListingsScreenState extends State<JobListingsScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<Map<String, dynamic>> jobs = [];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    try {
      final fetchedJobs = await _supabaseService.getJobs();
      setState(() {
        jobs = fetchedJobs;
      });
    } catch (e) {
      print("Error fetching jobs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Job Listings"), backgroundColor: Colors.pink),
      body: jobs.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                var job = jobs[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  child: ListTile(
                    title: Text(job['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${job['company']} - ${job['location']}"),
                    trailing: IconButton(
                      icon: Icon(Icons.open_in_new, color: Colors.pink),
                      onPressed: () {
                        // Open job application link
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
