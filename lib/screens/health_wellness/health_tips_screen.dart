import 'package:flutter/material.dart';
import 'package:women_app/services/supabase_service.dart';

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({super.key});

  @override
  _HealthTipsScreenState createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<Map<String, dynamic>> tips = [];

  @override
  void initState() {
    super.initState();
    _loadHealthTips();
  }

  Future<void> _loadHealthTips() async {
    try {
      final fetchedTips = await _supabaseService.getHealthTips();
      setState(() => tips = fetchedTips);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daily Health Tips"), backgroundColor: Colors.pink),
      body: ListView.builder(
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.health_and_safety, color: Colors.pink),
            title: Text(tips[index]['tip']),
          );
        },
      ),
    );
  }
}

extension on SupabaseService {
  getHealthTips() {}
}
