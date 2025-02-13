import 'dart:math';

class Task {
  final int id;
  final String title;
  final DateTime? alarmTime;

  // Constructor with an optional alarmTime
  Task({required this.title, this.alarmTime}) : id = Random().nextInt(100000);

  // Convert Task to a Map for Hive storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'alarmTime': alarmTime?.toIso8601String(),
    };
  }

  // Create a Task from a Map (Hive data format)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      alarmTime: map['alarmTime'] != null ? DateTime.parse(map['alarmTime']) : null,
    );
  }
}
