import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nadi/src/view/screens/appointment_booking_screen.dart';
import 'package:nadi/src/view/screens/nearest_doctor_screen.dart';
import 'package:nadi/src/viewmodel/patient_dashboad_viewmodel.dart';

import '../../viewmodel/appointment_booking_controller.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<PatientDashboard> {
  PatientDashBoardViewModel patientDashBoardViewModel =
      Get.put(PatientDashBoardViewModel());

  getData() async {
    await patientDashBoardViewModel.setConnection();
    await patientDashBoardViewModel.getPatientid();
    patientDashBoardViewModel.getAllDoctorList();
    patientDashBoardViewModel.getAllAppointments();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  height: (Get.height * 0.4) + 50,
                  width: Get.width,
                  child: Stack(
                    children: [
                      Image.network(
                        'https://images.pexels.com/photos/3985166/pexels-photo-3985166.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
                        fit: BoxFit.cover,
                        height: Get.height * 0.4,
                        width: Get.width,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 70,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(26),
                                topRight: Radius.circular(26)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: SizedBox(
                              width: Get.width,
                              child: Row(
                                children: [
                                  const Text(
                                    "Nearest Doctors",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => const NearestDoctorScreen());
                                    },
                                    child: const Text(
                                      "See All",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              height: 100,
              width: Get.width,
              child: Obx(() => patientDashBoardViewModel.isLoading.value
                  ? const CircularProgressIndicator()
                  : patientDashBoardViewModel.userList.isEmpty
                      ? const Center(
                          child: Text("No Doctor Found"),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount:
                              patientDashBoardViewModel.userList.length > 3
                                  ? 3
                                  : patientDashBoardViewModel.userList.length,
                          itemBuilder: (context, index) {
                            var doctor =
                                patientDashBoardViewModel.userList[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => AppointmentBookingScreen(
                                        doctorId: doctor.id,
                                        isUpdate: false,
                                      ));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                        height: 70,
                                        width: 70,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey.shade400),
                                        ),
                                        child: Image.asset(
                                          'assets/doctor.png',
                                          height: 40,
                                        )),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      doctor.name,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: Get.width,
                child: const Row(
                  children: [
                    Text(
                      "My Appointments",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    // Spacer(),
                    // Text(
                    //   "See All",
                    //   style:
                    //       TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                alignment: Alignment.center,
                width: Get.width,
                child: Obx(() => patientDashBoardViewModel.isLoading.value
                    ? const CircularProgressIndicator()
                    : patientDashBoardViewModel.appointmentList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: Get.height * 0.1,
                                ),
                                const SizedBox(
                                  // height: Get.height * 0.3,
                                  child: Text("No Appointment Found"),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                          reverse: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: patientDashBoardViewModel
                                .appointmentList.length,
                            itemBuilder: (context, index) {
                              var appointment = patientDashBoardViewModel
                                  .appointmentList[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    print("appointment.id ${appointment.id}");

                                    Get.put(AppointmentBookingController())
                                            .selectedDay =
                                        appointment.appointmentDate;

                                    Get.find<AppointmentBookingController>()
                                            .selectedTimeSlot =
                                        appointment.appointmentTime;

                                    Get.find<AppointmentBookingController>()
                                            .appointmentId =
                                        appointment.id.toString();

                                    Get.to(() => AppointmentBookingScreen(
                                          doctorId:
                                              appointment.doctorId.toString(),
                                          isUpdate: true,
                                        ));
                                  },
                                  child: Container(
                                    width: Get.width,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                          offset: const Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.grey.shade300),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: Get.width,
                                            child: Text(
                                              "Appointment date",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey.shade600),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                  Icons.access_time_outlined,
                                                  color: Colors.black87,
                                                  size: 24),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                () {
                                                  {
                                                    final formatter =
                                                        DateFormat(
                                                            'dd MMM yyyy');
                                                    return formatter.format(
                                                        appointment
                                                            .appointmentDate);
                                                  }
                                                }(),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black87),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                appointment.appointmentTime,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black87),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          const Divider(),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                  height: 40,
                                                  width: 40,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors
                                                            .grey.shade400),
                                                  ),
                                                  child: Image.asset(
                                                    'assets/doctor.png',
                                                    height: 22,
                                                  )),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(appointment.doctorName,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black87)),
                                              const Spacer(),
                                              Container(
                                                height: 24,
                                                width: 24,
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.green,
                                                ),
                                                child: appointment.status ==
                                                        "Scheduled"
                                                    ? const Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                        size: 16,
                                                      )
                                                    : const Icon(
                                                        Icons.cancel,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
