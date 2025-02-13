import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../models/task_model.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, Map<String, List<Task>>>(
      (ref) => TaskNotifier(),
);

class TaskNotifier extends StateNotifier<Map<String, List<Task>>> {
  final Box _taskBox = Hive.box('tasks');

  TaskNotifier() : super({}) {
    _loadTasks();
  }

  void _loadTasks() {
    final tasks = _taskBox.get('tasks', defaultValue: {});
    state = Map<String, List<Task>>.from(tasks.map((key, value) {
      return MapEntry(key, List<Task>.from(value.map((task) => Task.fromMap(task))));
    }));
  }

  void addTask(String date, Task task) {
    final taskList = state[date] ?? [];
    state = {
      ...state,
      date: [...taskList, task],
    };
    _taskBox.put('tasks', state);
  }

  void updateTask(String date, int index, Task updatedTask) {
    final taskList = state[date] ?? [];
    taskList[index] = updatedTask;
    state = {...state, date: List.from(taskList)};
    _taskBox.put('tasks', state);
  }

  void removeTask(String date, int index) {
    final taskList = state[date] ?? [];
    taskList.removeAt(index);
    state = {...state, date: List.from(taskList)};
    _taskBox.put('tasks', state);
  }
}
