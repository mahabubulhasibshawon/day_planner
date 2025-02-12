import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String details;

  Task({required this.title, required this.details});

  // Convert Task object to Map (if needed)
  Map<String, dynamic> toJson() => {
    'title': title,
    'details': details,
  };

  // Convert Map to Task object
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      details: json['details'],
    );
  }
}
