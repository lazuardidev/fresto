import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../provider/preferences_provider.dart';
import '../provider/scheduling_provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  void showDialogPermissionIsPermanentlyDenied(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Izinkan aplikasi untuk tampilkan notifikasi'),
        content: const Text(
            'Anda perlu memberikan izin ini dari pengaturan sistem.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Buka pengaturan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
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
