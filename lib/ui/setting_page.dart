import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/preferences_provider.dart';
import '../provider/scheduling_provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: Consumer<PreferencesProvider>(
        builder: (_, preferences, __) {
          return Consumer<SchedulingProvider>(
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
