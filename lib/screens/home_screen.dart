import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_day_planner/models/task_model.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 9, minute: 0); // Default time for the alarm

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
                Text('Plans ', style: TextStyle(fontSize: 26)),
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
    TextEditingController taskController = TextEditingController();
    TextEditingController detailsController = TextEditingController();

    // Add DateTime picker for alarm time
    DateTime selectedAlarmTime = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: taskController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            TextField(
              controller: detailsController,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Task Details'),
            ),
            // Add Time Picker for Alarm Time
            ListTile(
              title: Text('Set Alarm Time'),
              trailing: Text(DateFormat('hh:mm a').format(selectedAlarmTime)),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(selectedAlarmTime),
                );
                if (time != null) {
                  setState(() {
                    selectedAlarmTime = DateTime(
                      selectedAlarmTime.year,
                      selectedAlarmTime.month,
                      selectedAlarmTime.day,
                      time.hour,
                      time.minute,
                    );
                  });
                }
              },
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
              if (taskController.text.isNotEmpty) {
                // Create a Task object with alarm time
                final newTask = Task(
                  title: taskController.text,
                  alarmTime: selectedAlarmTime,
                );

                // Pass the Task object to addTask method
                ref.read(taskProvider.notifier).addTask(
                    DateFormat('yyyy-MM-dd').format(selectedDate),
                    newTask
                );

                _scheduleNotification(newTask);  // Pass the Task to the notification scheduler
              }
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }


  void _scheduleNotification(Task task) {
    if (task.alarmTime == null) return; // If no alarm time is set, do nothing

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: task.id,
        channelKey: 'basic_channel',
        title: 'Reminder: ${task.title}',
        body: 'Don\'t forget to do your task!',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar.fromDate(date: task.alarmTime!),
    );
  }

}
