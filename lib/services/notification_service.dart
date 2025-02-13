// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import '../models/task_model.dart';
//
// class NotificationService {
//   final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
//
//   Future<void> init() async {
//     tz.initializeTimeZones();
//
//     const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings settings = InitializationSettings(android: androidSettings);
//
//     await _notifications.initialize(settings);
//   }
//
//   Future<void> scheduleNotification(Task task, DateTime time) async {
//     await _notifications.zonedSchedule(
//       task.hashCode,
//       'Task Reminder',
//       task.title,
//       tz.TZDateTime.from(time, tz.local),
//       const NotificationDetails(android: AndroidNotificationDetails('channel_id', 'Task Alerts')),
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
//
//   Future<void> cancelNotification(Task task) async {
//     await _notifications.cancel(task.hashCode);
//   }
// }
