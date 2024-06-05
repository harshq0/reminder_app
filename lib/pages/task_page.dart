import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reminder_app/pages/reminder_page.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TimeOfDay time = TimeOfDay.now();
  String selectedDays = 'Monday';
  String selectedActivity = 'Wake up';
  List<Map<String, String>> reminders = [];

  Future<void> selectedTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != time) {
      setState(() {
        time = picked;
      });
    }
  }

  void setReminder() {
    String period = time.hour < 12 ? 'AM' : 'PM';
    Map<String, String> reminder = {
      'selectedDays': selectedDays,
      'selectedActivity': selectedActivity,
      'time': '${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} $period'
    };
    setState(() {
      reminders.add(reminder);
    });

    scheduleNotification().then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReminderPage(
              selectedDays: selectedDays,
              selectedActivity: selectedActivity,
              reminders: reminders),
        ),
      );
    });
  }

  Future<void> scheduleNotification() async {
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

    // Calculate the scheduled time
    DateTime now = DateTime.now();
    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await awesomeNotifications.createNotification(
      content: NotificationContent(
        id: reminders.length,
        channelKey: 'reminder',
        title: selectedActivity,
        body: 'Time to $selectedActivity on $selectedDays',
      ),
      schedule: NotificationCalendar(
        weekday: scheduledTime.weekday,
        hour: scheduledTime.hour,
        minute: scheduledTime.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    final List<String> activities = [
      'Wake up',
      'Go to gym',
      'Breakfast',
      'Meetings',
      'Lunch',
      'Quick nap',
      'Go to library',
      'Dinner',
      'Go to sleep'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Page', style: GoogleFonts.outfit()),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: DropdownButtonFormField(
                elevation: 0,
                value: selectedDays,
                items: days.map((String day) {
                  return DropdownMenuItem(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDays = value.toString();
                  });
                },
                decoration: const InputDecoration(labelText: 'Select Days'),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: DropdownButtonFormField(
                elevation: 0,
                value: selectedActivity,
                items: activities.map((activity) {
                  return DropdownMenuItem(
                    value: activity,
                    child: Text(activity),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedActivity = value.toString();
                  });
                },
                decoration: const InputDecoration(labelText: 'Select Activity'),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await selectedTime();
                  },
                  child: const Text('Set Time'),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.outfit(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: setReminder,
                    child: Text(
                      'Set Reminder',
                      style: GoogleFonts.outfit(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
