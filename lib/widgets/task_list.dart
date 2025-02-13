import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import 'package:intl/intl.dart';

class TaskList extends ConsumerWidget {
  final DateTime selectedDate;

  TaskList(this.selectedDate);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final tasksForSelectedDate = tasks[DateFormat('yyyy-MM-dd').format(selectedDate)] ?? [];

    return ListView.builder(
      itemCount: tasksForSelectedDate.length,
      itemBuilder: (context, index) {
        String task = tasksForSelectedDate[index].toString();
        return ListTile(
          title: Text(task),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              ref.read(taskProvider.notifier).removeTask(
                DateFormat('yyyy-MM-dd').format(selectedDate),
                index,
              );
            },
          ),
        );
      },
    );
  }
}
