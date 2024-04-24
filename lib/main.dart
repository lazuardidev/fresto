import 'dart:io';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fresto/presentation/pages/favorite_page.dart';
import 'package:fresto/presentation/pages/setting_page.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common/navigation.dart';
import 'common/styles.dart';
import 'data/api/api_service.dart';
import 'data/db/database_helper.dart';
import 'data/model/restaurant_list_model.dart';
import 'data/preferences/preferences_helper.dart';
import 'presentation/provider/database_notifier.dart';
import 'presentation/provider/preferences_notifier.dart';
import 'presentation/provider/restaurant_list_notifier.dart';
import 'presentation/provider/scheduling_notifier.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/detail_page.dart';
import 'utils/background_service.dart';
import 'utils/notification_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DatabaseNotifier(databaseHelper: DatabaseHelper()),
        ),
        ChangeNotifierProvider(
          create: (_) => RestaurantListNotifier(
            apiService: ApiService(http.Client()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SchedulingNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => PreferencesNotifier(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        )
      ],
      child: MaterialApp(
        title: 'Fresto',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: primaryColor,
                onPrimary: Colors.black,
                secondary: secondaryColor,
              ),
          scaffoldBackgroundColor: Colors.white,
          textTheme: myTextTheme,
          appBarTheme: AppBarTheme(
            elevation: 0,
            color: secondaryColor,
            titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        navigatorKey: navigatorKey,
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (_) => const HomePage(),
          FavoritePage.routeName: (_) => const FavoritePage(),
          SettingPage.routeName: (_) => const SettingPage(),
          DetailPage.routeName: (context) => DetailPage(
              restaurant:
                  ModalRoute.of(context)?.settings.arguments as Restaurant),
        },
      ),
    );
  }
}
