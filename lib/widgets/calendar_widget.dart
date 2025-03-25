import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/period_tracker_provider.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<PeriodTrackerProvider>(context);

    return TableCalendar(
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.month,
      selectedDayPredicate: (day) => provider.lastPeriodStart == day,
    );
  }
}
