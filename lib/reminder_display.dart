import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ReminderDisplay extends StatelessWidget {
  final List<String> reminders;
  final Function(int) onDelete; // Function to handle reminder deletion
  final Function(int, String) onEdit; // Function to handle reminder editing

  const ReminderDisplay({
    Key? key,
    required this.reminders,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Reminders:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10), // Add spacing between the title and reminders
        ...reminders.asMap().entries.map((entry) {
          final index = entry.key;
          final reminder = entry.value;
          return Slidable(
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    onDelete(index); // Call the onDelete function with index
                  },
                  icon: Icons.delete,
                  backgroundColor: Colors.red.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                SlidableAction(
                  onPressed: (context) {
                    _editReminder(context, index); // Call the _editReminder function with index
                  },
                  icon: Icons.edit,
                  backgroundColor: Colors.yellow.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    reminder,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  void _editReminder(BuildContext context, int index) {
    String editedReminder = reminders[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Reminder'),
          content: TextFormField(
            initialValue: editedReminder,
            onChanged: (value) {
              editedReminder = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onEdit(index, editedReminder); // Call the onEdit function with index and editedReminder
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
