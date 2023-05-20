import 'package:flutter/material.dart';
import 'package:nadi/src/utils/constants.dart';

class TimeSlotSelector extends StatefulWidget {
  @override
  _TimeSlotSelectorState createState() => _TimeSlotSelectorState();
}

class _TimeSlotSelectorState extends State<TimeSlotSelector> {
  List<String> timeSlots = [
    '10 AM - 11 AM',
    '11 AM - 12 PM',
    '12 PM - 1 PM',
    '1 PM - 2 PM',
    '2 PM - 3 PM',
    '3 PM - 4 PM',
  ];
  String? selectedTimeSlot;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: timeSlots.map((slot) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedTimeSlot = slot;
            });
          },
          child: Chip(
            label: Text(slot),
            backgroundColor: selectedTimeSlot == slot
                ? ConstantThings.accentColor
                : Colors.transparent,
            labelStyle: TextStyle(
              color: selectedTimeSlot == slot ? Colors.white : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }
}
