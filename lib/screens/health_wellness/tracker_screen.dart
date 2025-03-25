import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  String? _selectedMood;
  int _steps = 0;
  double _sleepHours = 0;
  int _waterIntake = 0;
  List<Map<String, dynamic>> _healthData = [];
  List<String> _healthTips = [];

  @override
  void initState() {
    super.initState();
    _fetchHealthData();
  }

  Future<void> _fetchHealthData() async {
    String userId = Supabase.instance.client.auth.currentUser?.id ?? "";
    if (userId.isNotEmpty) {
      final data = await _supabaseService.getHealthData(userId);
      final tips = await _supabaseService.getHealthTips(userId);
      setState(() {
        _healthData = data;
        _healthTips = tips;
      });
    }
  }

  Future<void> _saveHealthData() async {
    String userId = Supabase.instance.client.auth.currentUser?.id ?? "";
    if (userId.isNotEmpty && _selectedMood != null) {
      await _supabaseService.saveHealthData(userId, _selectedMood!, _steps, _sleepHours, _waterIntake);
      _fetchHealthData();
    }
  }

  Widget _buildChart() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: _healthData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value['steps'].toDouble()))
                  .toList(),
              isCurved: true,
              color: Colors.pink,
              barWidth: 3,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Health Tracker"), backgroundColor: Colors.pink),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedMood,
              items: ["Happy", "Sad", "Neutral", "Energetic"]
                  .map((mood) => DropdownMenuItem(value: mood, child: Text(mood)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedMood = value),
              decoration: const InputDecoration(labelText: "Today's Mood"),
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Steps Walked"),
              keyboardType: TextInputType.number,
              onChanged: (value) => _steps = int.tryParse(value) ?? 0,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Sleep Hours"),
              keyboardType: TextInputType.number,
              onChanged: (value) => _sleepHours = double.tryParse(value) ?? 0,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Water Intake (ml)"),
              keyboardType: TextInputType.number,
              onChanged: (value) => _waterIntake = int.tryParse(value) ?? 0,
            ),
            ElevatedButton(
              onPressed: _saveHealthData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              child: const Text("Save"),
            ),
            const Divider(),
            _buildChart(),
            ..._healthTips.map((tip) => Card(child: Padding(padding: const EdgeInsets.all(8.0), child: Text(tip)))),
          ],
        ),
      ),
    );
  }
}
