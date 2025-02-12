import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';
import 'package:intl/intl.dart';

class TaskList extends ConsumerWidget {
  final DateTime selectedDate;
  TaskList(this.selectedDate);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider)[DateFormat('yyyy-MM-dd').format(selectedDate)] ?? [];

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];

        return Card(
          child: ListTile(
            title: Text(task.title),      // ✅ Show task title
            subtitle: Text(task.details), // ✅ Show task details
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditTaskDialog(context, ref, index, task);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    ref.read(taskProvider.notifier).removeTask(DateFormat('yyyy-MM-dd').format(selectedDate), index);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditTaskDialog(BuildContext context, WidgetRef ref, int index, Task task) {
    TextEditingController titleController = TextEditingController(text: task.title);
    TextEditingController detailsController = TextEditingController(text: task.details);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: detailsController,
              decoration: InputDecoration(labelText: 'Task Details'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(taskProvider.notifier).updateTask(
                  DateFormat('yyyy-MM-dd').format(selectedDate),
                  index,
                  titleController.text,
                  detailsController.text);
              Navigator.pop(context);
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}
