import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nadi/src/utils/constants.dart';
import 'package:nadi/src/view/widgets/timeslot_widget.dart';
import 'package:nadi/src/viewmodel/appointment_booking_controller.dart';
import 'package:weekly_date_picker/weekly_date_picker.dart';

// ignore: must_be_immutable
class AppointmentBookingScreen extends StatefulWidget {
  String doctorId;
  bool isUpdate;
  AppointmentBookingScreen(
      {super.key, required this.doctorId, required this.isUpdate});

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  final AppointmentBookingController appointmentBookingController =
      Get.put(AppointmentBookingController());

  setData() {
    appointmentBookingController.getPatientid();
    appointmentBookingController.setConnection();
  }

  @override
  void initState() {
    appointmentBookingController.doctorId = widget.doctorId;
    appointmentBookingController.isUpdate = widget.isUpdate;
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          elevation: 0,
          title: const Row(
            children: [
              Text(
                "Book Appointment",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: Get.width,
                child: const Text(
                  " Choose Date",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              WeeklyDatePicker(
                selectedBackgroundColor: ConstantThings.accentColor,

                weekdayText: '',
                enableWeeknumberText: false,
                backgroundColor: Colors.grey.shade100,
                selectedDay:
                    appointmentBookingController.selectedDay, // DateTime
                changeDay: (value) => setState(() {
                  DateTime currentDate = DateTime.now();
                  if (value
                      .add(const Duration(days: 1))
                      .isBefore(currentDate)) {
                    Fluttertoast.showToast(
                        msg: 'Please select a date after today');
                  } else {
                    appointmentBookingController.selectedDay = value;
                  }
                }),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: Get.width,
                child: const Text(
                  " Choose Time",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const TimeSlotSelector(),
              const Spacer(),
           widget.isUpdate?  Row(children: [

             SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // height: 48,
                  width: Get.width/2.2,
                  child: TextButton(
                    onPressed: () {
                      appointmentBookingController.cancelAppointment();
                    },
                    child: const Text(
                      'Cancel ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Spacer(),
               SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    color: ConstantThings.accentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // height: 48,
                  width: Get.width/ 2.2,
                  child: TextButton(
                    onPressed: () {
                      appointmentBookingController.updateAppointment();
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),

           ],) :    SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    color: ConstantThings.accentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // height: 48,
                  width: Get.width,
                  child: TextButton(
                    onPressed: () {
                      appointmentBookingController.bookAppointment();
                    },
                    child: const Text(
                      'Book Appointment',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              )
            ],
          ),
        ));
  }
}
