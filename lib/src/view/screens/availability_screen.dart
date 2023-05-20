import 'package:flutter/material.dart';

class ManageAvailabilityScreen extends StatelessWidget {
  const ManageAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Availability'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set Availability:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Date:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Show date picker
              },
              child: const Text('Select Date'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Time Slots:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                TimeSlotChip(time: '9:00 AM'),
                TimeSlotChip(time: '10:00 AM'),
                TimeSlotChip(time: '11:00 AM'),
                TimeSlotChip(time: '12:00 PM'),
                TimeSlotChip(time: '1:00 PM'),
                TimeSlotChip(time: '2:00 PM'),
                TimeSlotChip(time: '3:00 PM'),
                TimeSlotChip(time: '4:00 PM'),
                TimeSlotChip(time: '5:00 PM'),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Save availability
              },
              child: const Text('Save Availability'),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeSlotChip extends StatefulWidget {
  final String time;

  const TimeSlotChip({super.key, required this.time});

  @override
  _TimeSlotChipState createState() => _TimeSlotChipState();
}

class _TimeSlotChipState extends State<TimeSlotChip> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(widget.time),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          isSelected = selected;
        });
      },
    );
  }
}
