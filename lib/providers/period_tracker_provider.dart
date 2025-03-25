import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/notification_service.dart';

class PeriodTrackerProvider extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;
  final NotificationService notificationService = NotificationService(); // ✅ Create an instance

  DateTime? lastPeriodStart;
  int cycleLength = 28;
  int periodLength = 5;
  Map<String, dynamic> symptoms = {};
  double? weight;
  double? waterIntake;
  bool isLoading = true;

  PeriodTrackerProvider() {
    fetchPeriodData();
  }

  /// ✅ **Fetch Period Data from Supabase**
  Future<void> fetchPeriodData() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    final response = await supabase
        .from('period_tracker')
        .select('*')
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response != null) {
      lastPeriodStart = response['last_period_date'] != null
          ? DateTime.parse(response['last_period_date'])
          : null;
      cycleLength = response['cycle_length'];
      periodLength = response['period_length'];
      symptoms = response['symptoms'] ?? {};
      weight = response['weight'];
      waterIntake = response['water_intake'];

      if (lastPeriodStart != null) {
        notificationService.schedulePeriodReminder(lastPeriodStart!, cycleLength); // ✅ Fixed
      }
    }

    isLoading = false;
    notifyListeners();
  }

  /// ✅ **Update Last Period in Supabase**
  Future<void> updateLastPeriod(DateTime date) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    lastPeriodStart = date;

    await supabase.from('period_tracker').insert({
      'user_id': user.id,
      'last_period_date': date.toIso8601String(),
      'cycle_length': cycleLength,
      'period_length': periodLength,
    });

    notificationService.schedulePeriodReminder(date, cycleLength); // ✅ Fixed
    notifyListeners();
  }

  /// ✅ **Fetch Cycle History**
  Future<List<Map<String, dynamic>>> fetchCycleHistory() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final response = await supabase
        .from('period_tracker')
        .select('*')
        .eq('user_id', user.id)
        .order('last_period_date', ascending: false);

    return response ?? [];
  }
}
