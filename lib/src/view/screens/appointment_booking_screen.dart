import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nadi/src/utils/constants.dart';
import 'package:nadi/src/view/widgets/timeslot_widget.dart';
import 'package:nadi/src/viewmodel/appointment_booking_controller.dart';
import 'package:weekly_date_picker/weekly_date_picker.dart';

// ignore: must_be_immutable
class AppointmentBookingScreen extends StatefulWidget {
  String doctorId;
  bool isUpdate;
  bool isFromDoctor;
  AppointmentBookingScreen(
      {super.key,
      required this.doctorId,
      required this.isUpdate,
      required this.isFromDoctor});

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
    appointmentBookingController.isFromDoctor = widget.isFromDoctor;
    setData();
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<AppointmentBookingController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(appointmentBookingController.doctorFcm);
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          elevation: 0,
          title: Row(
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
              widget.isUpdate
                  ? Row(
                      children: [
                        SafeArea(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            // height: 48,
                            width: Get.width / 2.2,
                            child: TextButton(
                              onPressed: () {
                                showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Cancel Appointment'),
                                        content: const Text(
                                            'Are you sure you want to cancel this appointment?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancel',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                          ),
                                          TextButton(
                                            child: const Text(
                                              'Confirm',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              appointmentBookingController
                                                  .cancelAppointment();
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                          ),
                                        ],
                                      );
                                    });
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
                            width: Get.width / 2.2,
                            child: TextButton(
                              onPressed: () {
                                appointmentBookingController
                                    .updateAppointment();
                              },
                              child: const Text(
                                'Update',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SafeArea(
                      child: Obx(() => InkWell(
                            onTap: () {
                              appointmentBookingController.bookAppointment();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: ConstantThings.accentColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 48,
                                                      alignment: Alignment.center,

                              width: Get.width,
                              child: appointmentBookingController
                                      .isBookLoading.value
                                  ? SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: LoadingAnimationWidget.waveDots(
                                          color: Colors.white,
                                          // rightDotColor: Colors.white,
                                          size: 45),
                                    )
                                  : const Text(
                                      'Book Appointment',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          )),
                    ),
              const SizedBox(
                height: 16,
              )
            ],
          ),
        ));
  }
}
