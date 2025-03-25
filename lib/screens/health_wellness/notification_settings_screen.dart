import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  _NotificationSettingsScreenState createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool dailyReminder = true;
  bool periodReminder = true;
  bool ovulationReminder = true;
  final NotificationService notificationService = NotificationService(); // ✅ Create an instance

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  /// ✅ Load User Preferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dailyReminder = prefs.getBool('daily_reminder') ?? true;
      periodReminder = prefs.getBool('period_reminder') ?? true;
      ovulationReminder = prefs.getBool('ovulation_reminder') ?? true;
    });
  }

  /// ✅ Save User Preferences
  Future<void> _savePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    _handleNotifications();
  }

  /// ✅ Handle Notification Scheduling (Now Uses an Instance)
  void _handleNotifications() {
    if (dailyReminder) NotificationService.scheduleDailyReminder(); // Static method
    if (periodReminder) notificationService.schedulePeriodReminder(DateTime.now(), 28);
    if (ovulationReminder) notificationService.scheduleOvulationReminder(DateTime.now(), 28);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification Settings"), backgroundColor: Colors.pink),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSwitchTile("Daily Health Reminder", dailyReminder, (value) {
              setState(() => dailyReminder = value);
              _savePreference('daily_reminder', value);
            }),
            _buildSwitchTile("Period Reminder", periodReminder, (value) {
              setState(() => periodReminder = value);
              _savePreference('period_reminder', value);
            }),
            _buildSwitchTile("Ovulation Reminder", ovulationReminder, (value) {
              setState(() => ovulationReminder = value);
              _savePreference('ovulation_reminder', value);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
