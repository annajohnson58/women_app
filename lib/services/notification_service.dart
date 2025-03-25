import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// ✅ **Initialize Notifications & Alarm Manager**
  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings);
    await AndroidAlarmManager.initialize();
    tz.initializeTimeZones();
  }

  /// ✅ **Request Exact Alarm Permission for Android 12+**
  Future<bool> requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isGranted) {
      return true; // ✅ Permission already granted
    }

    if (await Permission.scheduleExactAlarm.request().isGranted) {
      return true; // ✅ Permission granted now
    }

    openAppSettings(); // ❌ Permission denied, open settings
    return false;
  }

  /// ✅ **Schedule Daily Reminder at 9:00 PM (if enabled)**
  static Future<void> scheduleDailyReminder() async {
    final prefs = await SharedPreferences.getInstance();
    bool isEnabled = prefs.getBool('daily_reminder') ?? true;
    if (!isEnabled) return;

    await _notificationsPlugin.zonedSchedule(
      0,
      "Health Tracker Reminder",
      "Don't forget to log your health stats today!",
      _nextInstanceOfTime(21, 0),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "health_channel",
          "Health Tracker",
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// ✅ **Schedule Period Reminder (2 Days Before Next Period)**
  Future<void> schedulePeriodReminder(DateTime lastPeriod, int cycleLength) async {
    bool isGranted = await requestExactAlarmPermission();
    if (!isGranted) {
      print("⚠️ Exact Alarm permission required!");
      return;
    }

    DateTime nextPeriod = lastPeriod.add(Duration(days: cycleLength));
    DateTime reminderDate = nextPeriod.subtract(Duration(days: 2));

    if (reminderDate.isBefore(DateTime.now())) return;

    await AndroidAlarmManager.oneShotAt(
      reminderDate,
      1, // Unique alarm ID
      () => showNotification("Upcoming Period Reminder",
          "Your next period is expected on ${_formatDate(nextPeriod)}."),
      exact: true,
      wakeup: true,
    );
  }

  /// ✅ **Schedule Ovulation Reminder (Mid-Cycle)**
  Future<void> scheduleOvulationReminder(DateTime lastPeriod, int cycleLength) async {
    final prefs = await SharedPreferences.getInstance();
    bool isEnabled = prefs.getBool('ovulation_reminder') ?? true;
    if (!isEnabled) return;

    DateTime ovulationDate = lastPeriod.add(Duration(days: (cycleLength ~/ 2)));

    if (ovulationDate.isBefore(DateTime.now())) return;

    await AndroidAlarmManager.oneShotAt(
      ovulationDate,
      2, // Unique alarm ID
      () => showNotification("Ovulation Reminder", "Your ovulation window starts soon!"),
      exact: true,
      wakeup: true,
    );
  }

  /// ✅ **Show Local Notification**
  Future<void> showNotification(String title, String body) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        "default_channel",
        "General Notifications",
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      ),
    );

    await _notificationsPlugin.show(0, title, body, platformChannelSpecifics);
  }

  /// ✅ **Cancel All Notifications**
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  /// ✅ **Format Date as "Month Day"**
  static String _formatDate(DateTime date) {
    return "${_monthName(date.month)} ${date.day}";
  }

  /// ✅ **Get Month Name from Number**
  static String _monthName(int month) {
    return [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ][month - 1];
  }

  /// ✅ **Get Next Notification Time**
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
