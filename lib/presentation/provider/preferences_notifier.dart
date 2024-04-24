import 'package:flutter/material.dart';
import '../../data/preferences/preferences_helper.dart';

class PreferencesNotifier extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesNotifier({required this.preferencesHelper}) {
    _getDailyReminderPreferences();
  }

  bool _isDailyReminderActive = false;
  bool get isDailyReminderActive => _isDailyReminderActive;

  void _getDailyReminderPreferences() async {
    _isDailyReminderActive = await preferencesHelper.isDailyReminderActive;
    notifyListeners();
  }

  void enableDailyReminder(bool value) {
    preferencesHelper.setDailyReminder(value);
    _getDailyReminderPreferences();
  }
}
