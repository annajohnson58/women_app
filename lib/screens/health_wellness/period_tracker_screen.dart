import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:women_app/providers/period_tracker_provider.dart';
import 'package:women_app/widgets/calendar_widget.dart';
import 'cycle_history_screen.dart';

class PeriodTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<PeriodTrackerProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Period Tracker'), backgroundColor: Colors.pink),
      body: Column(
        children: [
          CalendarWidget(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );

              if (selectedDate != null) {
                provider.updateLastPeriod(selectedDate); // ✅ Use selected date
              }
            },
            child: Text("Log Last Period"),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CycleHistoryScreen()),
              );
            },
            child: Text("View Cycle History"),
          ),
        ],
      ),
    );
  }
}
