import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:women_app/providers/period_tracker_provider.dart';

class CycleHistoryScreen extends StatelessWidget {
  const CycleHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cycle History')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: Provider.of<PeriodTrackerProvider>(context, listen: false).fetchCycleHistory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          List<Map<String, dynamic>> history = snapshot.data!;

          if (history.isEmpty) {
            return Center(child: Text("No cycle history available."));
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              DateTime periodDate = DateTime.parse(history[index]['last_period_date']);
              int cycleLength = history[index]['cycle_length'];
              int periodLength = history[index]['period_length'];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: ListTile(
                  title: Text(
                    "Cycle Start: ${DateFormat('MMMM d, yyyy').format(periodDate)}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Cycle Length: $cycleLength days\nPeriod Length: $periodLength days",
                  ),
                  trailing: Icon(Icons.history, color: Colors.pink),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
