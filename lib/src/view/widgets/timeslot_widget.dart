import 'package:flutter/material.dart';
// import 'package:get/get/get.dart';
import 'package:get/get.dart';
import 'package:nadi/src/utils/constants.dart';
import 'package:nadi/src/viewmodel/appointment_booking_controller.dart';

class TimeSlotSelector extends StatefulWidget {
  const TimeSlotSelector({super.key});

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
  // String? selectedTimeSlot;
  AppointmentBookingController appointmentBookingController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // spacing: 8.0,
      runSpacing: 8.0,
      children: timeSlots.map((slot) {
        return GestureDetector(
          onTap: () {
            setState(() {
           appointmentBookingController.   selectedTimeSlot = slot;
            });
          },
          child: Chip(
            label: Text(slot),
            backgroundColor:appointmentBookingController. selectedTimeSlot == slot
                ? ConstantThings.accentColor
                : Colors.transparent,
            labelStyle: TextStyle(
              color: appointmentBookingController.selectedTimeSlot == slot ? Colors.white : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }
}
