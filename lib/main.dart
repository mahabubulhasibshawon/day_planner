import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'screens/home_screen.dart';
import 'providers/task_provider.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open the 'tasks' box
  await Hive.initFlutter();
  await Hive.openBox('tasks');

  // Initialize timezones for notifications
  tz.initializeTimeZones();

  // Initialize Flutter Local Notifications
  await _initializeNotifications();

  // Run the app with Riverpod state management
  runApp(ProviderScope(child: MyApp()));
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Function to initialize the notification settings
Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Offline Day Planner',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

// Function to schedule a task alarm (notification)
Future<void> scheduleTaskAlarm(DateTime alarmTime, String taskTitle) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'your_channel_id', // Replace with your channel ID
    'your_channel_name', // Replace with your channel name
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0, // Notification ID
    'Task Reminder', // Notification title
    taskTitle, // Notification content (task title)
    _convertToTimezone(alarmTime), // Time of notification
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.wallClockTime,
  );
}

// Helper function to convert to local timezone
tz.TZDateTime _convertToTimezone(DateTime dateTime) {
  return tz.TZDateTime.from(dateTime, tz.local);
}
