import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import '../../utils/background_service.dart';
import '../../utils/date_time_helper.dart';

class SchedulingNotifier extends ChangeNotifier {
  bool _isScheduled = false;
  bool get isScheduled => _isScheduled;

  Future<bool> scheduledReminder(bool value) async {
    _isScheduled = value;

    if (_isScheduled) {
      notifyListeners();
      return AndroidAlarmManager.periodic(
        const Duration(days: 1),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
