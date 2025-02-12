// widgets/task_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
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
        return Card(
          child: ListTile(
            title: Text(tasks[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditTaskDialog(context, ref, index, tasks[index]);
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

  void _showEditTaskDialog(BuildContext context, WidgetRef ref, int index, String currentTask) {
    TextEditingController taskController = TextEditingController(text: currentTask);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Task'),
        content: TextField(
          controller: taskController,
          decoration: InputDecoration(labelText: 'Task Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(onPressed: () { ref.read(taskProvider.notifier).updateTask(DateFormat('yyyy-MM-dd').format(selectedDate), index, taskController.text); Navigator.pop(context); }, child: Text('Update')),
        ],
      ),
    );
  }
}
