import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/preferences_notifier.dart';
import '../provider/scheduling_notifier.dart';

class SettingPage extends StatelessWidget {
  static const routeName = '/setting_page';
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: Consumer<PreferencesNotifier>(
        builder: (_, preferences, __) {
          return Consumer<SchedulingNotifier>(
            builder: (_, scheduled, __) {
              void setReminder(bool value) {
                scheduled.scheduledReminder(value);
                preferences.enableDailyReminder(value);
              }

              return SwitchListTile(
                title: const Text('Daily Reminder'),
                value: preferences.isDailyReminderActive,
                onChanged: (value) async {
                  if (Platform.isAndroid) {
                    setReminder(value);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
