import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:remapp/reminder_display.dart'; // Import your ReminderDisplay widget

class ReminderForm extends StatefulWidget {
  const ReminderForm({Key? key}) : super(key: key);

  @override
  _ReminderFormState createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  String? selectedDay;
  TimeOfDay? selectedTime;
  String? selectedActivity;
  List<String> reminders = [];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initNotifications(); // Initialize notifications
  }

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> scheduleNotification(String reminderText) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    // Schedule the notification
    await flutterLocalNotificationsPlugin.show(
      0,
      'Reminder',
      reminderText,
      platformChannelSpecifics,
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _deleteReminder(int index) {
    setState(() {
      reminders.removeAt(index);
    });
  }

  void _editReminder(int index, String editedReminder) {
    setState(() {
      reminders[index] = editedReminder;
    });

    // Schedule a notification for the edited reminder
    scheduleNotification(editedReminder);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (reminders.isNotEmpty)
          ReminderDisplay(
            reminders: reminders,
            onDelete: _deleteReminder,
            onEdit: _editReminder,
          ),
        const Divider(),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        hint: const Text('Select Day'),
                        items: <String>[
                          'Monday',
                          'Tuesday',
                          'Wednesday',
                          'Thursday',
                          'Friday',
                          'Saturday',
                          'Sunday'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDay = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _selectTime(context),
                        child: Text(selectedTime != null
                            ? 'Selected Time: ${selectedTime!.format(context)}'
                            : 'Select Time'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  hint: const Text('Select Activity'),
                  items: <String>[
                    'Wake up',
                    'Go to gym',
                    'Breakfast',
                    'Meetings',
                    'Lunch',
                    'Quick nap',
                    'Go to Library',
                    'Dinner',
                    'Go to sleep'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedActivity = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  clipBehavior: Clip.antiAlias,
                  onPressed: () {
                    // Handle setting or updating the reminder
                    if (selectedDay != null &&
                        selectedTime != null &&
                        selectedActivity != null) {
                      final reminderText =
                          'Day: $selectedDay, Time: ${selectedTime!.format(context)}, Activity: $selectedActivity';
                      setState(() {
                        reminders.insert(0, reminderText); // Insert at the top
                      });
                      // Schedule a notification for the new reminder
                      scheduleNotification(reminderText);
                    }
                  },
                  child: const Text('Set Reminder'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
