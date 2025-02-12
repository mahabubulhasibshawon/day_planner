import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'dart:convert';

import '../models/task_model.dart';


final taskProvider =
StateNotifierProvider<TaskNotifier, Map<String, List<Task>>>(
        (ref) => TaskNotifier());

class TaskNotifier extends StateNotifier<Map<String, List<Task>>> {
  final Box _taskBox = Hive.box('tasks');

  TaskNotifier() : super({}) {
    _loadTasks();
  }

  void _loadTasks() {
    final tasks = _taskBox.get('tasks', defaultValue: {});
    if (tasks != null && tasks is Map<String, dynamic>) {
      state = Map<String, List<Task>>.from(
        tasks.map((key, value) {
          // Ensure each value is decoded correctly as a List<Task>
          return MapEntry(
            key,
            (value as List<dynamic>).map((task) {
              // Assuming each item is a Map
              if (task is Map<String, dynamic>) {
                return Task.fromJson(task);
              } else {
                return Task(title: '', details: ''); // Fallback if task is not a Map
              }
            }).toList(),
          );
        }),
      );
    }
  }


  void addTask(String date, String title, String details) {
    final newTask = Task(title: title, details: details);
    state = {
      ...state,
      date: [...(state[date] ?? []), newTask]
    };
    _saveTasks();
  }

  void updateTask(String date, int index, String newTitle, String newDetails) {
    final updatedTask = Task(title: newTitle, details: newDetails);
    state = {
      ...state,
      date: List.from(state[date] ?? [])..[index] = updatedTask
    };
    _saveTasks();
  }

  void removeTask(String date, int index) {
    state = {
      ...state,
      date: List.from(state[date] ?? [])..removeAt(index)
    };
    _saveTasks();
  }

  void _saveTasks() {
    _taskBox.put(
      'tasks',
      state.map((key, value) => MapEntry(
        key,
        value.map((task) => task.toJson()).toList(),  // Ensure each task is serialized as a Map
      )),
    );
  }

}