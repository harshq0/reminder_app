import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reminder_app/pages/task_page.dart';

class ReminderPage extends StatefulWidget {
  final String selectedDays;
  final String selectedActivity;
  final List<Map<String, String>> reminders;

  const ReminderPage({
    super.key,
    required this.selectedDays,
    required this.selectedActivity,
    required this.reminders,
  });

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TaskPage(),
              ),
            ),
            icon: const Icon(Icons.add),
          ),
        ],
        title: Text(
          'Reminder App',
          style: GoogleFonts.outfit(),
        ),
      ),
      body: widget.reminders.isEmpty
          ? const Center(
              child: Text(
                'No reminders added yet.',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: widget.reminders.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: ListTile(
                      title: Text(
                        widget.reminders[index]['selectedActivity'] ?? '',
                        style: GoogleFonts.outfit(fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.reminders[index]['selectedDays'] ?? '',
                            style: GoogleFonts.outfit(fontSize: 14),
                          ),
                          Text(
                            widget.reminders[index]['time'] ?? '',
                            style: GoogleFonts.outfit(fontSize: 11),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            widget.reminders.removeAt(index);
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
