import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'dart:convert';

final taskProvider =
    StateNotifierProvider<TaskNotifier, Map<String, List<String>>>(
        (ref) => TaskNotifier());

class TaskNotifier extends StateNotifier<Map<String, List<String>>> {
  final Box _taskBox = Hive.box('tasks');

  TaskNotifier() : super({}) {
    _loadTasks();
  }

  void _loadTasks() {
    final tasks = _taskBox.get('tasks', defaultValue: {});
    state = Map<String, List<String>>.from(tasks);
  }

  void addTask(String date, String task) {
    state = {
      ...state,
      date: [...(state[date] ?? []), task]
    };
    _taskBox.put('tasks', state);
  }

  void updateTask(String date, int index, String newTask) {
    state = {...state, date: List.from(state[date] ?? [])..[index] = newTask};
    _taskBox.put('tasks', state);
  }

  void removeTask(String date, int index) {
    state = {...state, date: List.from(state[date] ?? [])..removeAt(index)};
    _taskBox.put('tasks', state);
  }
}
