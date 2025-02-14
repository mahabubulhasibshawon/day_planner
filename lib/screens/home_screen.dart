import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../services/notification_service.dart';
import '../widgets/task_tile.dart';
import '../widgets/weekly_calendar.dart';

// Create a provider for selected date
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            WeeklyCalendar(
              selectedDate: selectedDate,
              onDaySelected: (date) {
                ref.read(selectedDateProvider.notifier).state = date;
              },
            ),
            Expanded(
              child: tasks.isEmpty
                  ? Center(
                child: Text(
                  'No tasks for this day',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  if (task.alarmTime != null &&
                      isSameDay(task.alarmTime!, selectedDate)) {
                    return TaskTile(task: task);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
