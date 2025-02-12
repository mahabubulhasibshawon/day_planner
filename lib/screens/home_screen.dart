import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(DateFormat('MMM d').format(selectedDate))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          spacing: 10,
          children: [
            _buildWeekCalendar(),
            Row(
              children: [
                Text('Plans ', style: TextStyle(fontSize: 26),),
              ],
            ),
            Expanded(child: TaskList(selectedDate)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context, ref);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildWeekCalendar() {
    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          DateTime date = DateTime.now()
              .subtract(Duration(days: DateTime.now().weekday - 1 - index));
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
              });
            },
            child: Container(
              height: 50,
              width: 50,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: selectedDate.day == date.day
                    ? Colors.green
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat.E().format(date)),
                  Text(date.day.toString()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    TextEditingController titleController = TextEditingController();
    TextEditingController detailsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: detailsController,
              maxLines: 3,
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
              if (titleController.text.isNotEmpty) {
                ref.read(taskProvider.notifier).addTask(
                    DateFormat('yyyy-MM-dd').format(selectedDate),
                    titleController.text,
                    detailsController.text);
              }
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

}
