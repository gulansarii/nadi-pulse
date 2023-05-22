import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:intl/intl.dart';
import 'package:nadi/src/view/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants.dart';
import '../../viewmodel/appointment_booking_controller.dart';
import '../../viewmodel/doctor_dashboard_controller.dart';
import 'appointment_booking_screen.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard>
    with SingleTickerProviderStateMixin<DoctorDashboard> {
  DoctorDashboardController doctorDashboardController =
      Get.put(DoctorDashboardController());
  late TabController tabController;

  getData() async {
    await doctorDashboardController.setConnection();
    await doctorDashboardController.getPatientid();
    doctorDashboardController.getUpcomingAppointments();
    doctorDashboardController.getPastAppointments();
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);

    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration:
                  const BoxDecoration(color: ConstantThings.accentColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/doctor.png')),
                  const SizedBox(height: 10),
                  Obx(
                    () => Text(
                      doctorDashboardController.loggedInUserName.value
                          .toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await Get.deleteAll();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Get.back();
                Get.offAll(() => const SplashScreen());
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        title: const Text(
          "My Bookings",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SegmentedTabControl(
                  controller: tabController,
                  radius: const Radius.circular(12),
                  indicatorColor: ConstantThings.accentColor,
                  squeezeIntensity: 1,
                  height: 45,
                  tabPadding: const EdgeInsets.symmetric(horizontal: 8),
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  tabs: [
                    SegmentTab(
                      backgroundColor:
                          ConstantThings.accentColor.withOpacity(0.78),
                      label: 'Upcoming',
                    ),
                    SegmentTab(
                      backgroundColor:
                          ConstantThings.accentColor.withOpacity(0.78),
                      label: 'Past',
                    ),
                  ],
                ),
              ),
              // Sample pages
              Padding(
                padding: const EdgeInsets.only(top: 70),
                child: TabBarView(
                  controller: tabController,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    upcomingList(),
                    pastList()
                    // Chats(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget upcomingList() {
    return RefreshIndicator(
      onRefresh: () async {
        await doctorDashboardController.getUpcomingAppointments();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                alignment: Alignment.center,
                width: Get.width,
                child: Obx(() => doctorDashboardController
                        .isAppointmentLoading.value
                    ? SizedBox(
                        height: Get.height * 0.7,
                        child: const Center(child: CircularProgressIndicator()))
                    : doctorDashboardController.upcomingAppointmentList.isEmpty
                        ? SizedBox(
                            height: Get.height * 0.7,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: Get.height * 0.1,
                                  ),
                                  const SizedBox(
                                    // height: Get.height * 0.3,
                                    child:
                                        Text("No Upcoming Appointment Found"),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: doctorDashboardController
                                .upcomingAppointmentList.length,
                            itemBuilder: (context, index) {
                              var appointment = doctorDashboardController
                                  .upcomingAppointmentList[index];
                              return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (appointment.status == "Pending") {
                                        Fluttertoast.showToast(
                                            msg:
                                                "You can't update pending appointment");
                                        return;
                                      }

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
                                            doctorId: appointment.patientId
                                                .toString(),
                                            isUpdate: true,
                                            isFromDoctor: true,
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
                                                    color:
                                                        Colors.grey.shade600),
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
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black87),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  appointment.appointmentTime,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                                SizedBox(
                                                    height: 45,
                                                    width: 45,
                                                    child: Image.asset(
                                                      'assets/person.png',
                                                      height: 22,
                                                    )),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                SizedBox(
                                                  width: Get.width * 0.28,
                                                  child: Text(
                                                      appointment.doctorName
                                                          .capitalizeFirst!,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Colors.black87)),
                                                ),
                                                const Spacer(),
                                                appointment.status == "Pending"
                                                    ? Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              print(
                                                                  "appointment.id ${appointment.fcmToken}");
                                                              doctorDashboardController
                                                                  .rejectAppointment(
                                                                      appointment
                                                                          .id,
                                                                      appointment
                                                                          .fcmToken!,
                                                                      appointment
                                                                          .appointmentDate);
                                                            },
                                                            child: Container(
                                                              height: 30,
                                                              width: 80,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade200,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                              ),
                                                              child: const Text(
                                                                "Reject",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              print(
                                                                  "appointment.id ${appointment.fcmToken}");
                                                              doctorDashboardController
                                                                  .acceptAppointment(
                                                                      appointment
                                                                          .id,
                                                                      appointment
                                                                          .fcmToken!,
                                                                      appointment
                                                                          .appointmentDate);
                                                            },
                                                            child: Container(
                                                              height: 30,
                                                              width: 80,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade200,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                              ),
                                                              child: const Text(
                                                                "Accept",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(
                                                        height: 30,
                                                        width: 80,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: () {
                                                            switch (appointment
                                                                .status) {
                                                              case 'Pending':
                                                                return ConstantThings
                                                                    .accentColor;
                                                              case 'Cancelled':
                                                                return Colors
                                                                    .red
                                                                    .shade400;
                                                              case 'Completed':
                                                                return Colors
                                                                    .green
                                                                    .shade300;
                                                              case 'Scheduled':
                                                                return ConstantThings
                                                                    .accentColor;
                                                              default:
                                                                return Colors
                                                                    .grey
                                                                    .shade50;
                                                            }
                                                          }(),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: Text(
                                                          appointment.status,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                            })),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pastList() {
    return RefreshIndicator(
      onRefresh: () async {
        doctorDashboardController.getPastAppointments();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                alignment: Alignment.center,
                width: Get.width,
                child: Obx(() => doctorDashboardController.isLoading.value
                    ? SizedBox(
                        height: Get.height * 0.7,
                        child: const Center(child: CircularProgressIndicator()))
                    : doctorDashboardController.pastAppointmentList.isEmpty
                        ? SizedBox(
                            height: Get.height * 0.7,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: Get.height * 0.1,
                                  ),
                                  const SizedBox(
                                    // height: Get.height * 0.3,
                                    child: Text("No Past Appointment Found"),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            reverse: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: doctorDashboardController
                                .pastAppointmentList.length,
                            itemBuilder: (context, index) {
                              var appointment = doctorDashboardController
                                  .pastAppointmentList[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    // if (appointment.status == "Cancelled") {
                                    //   Fluttertoast.showToast(
                                    //       msg:
                                    //           "You cannot view cancelled appointment");
                                    //   return;
                                    // }

                                    // print("appointment.id ${appointment.id}");

                                    // Get.put(AppointmentBookingController())
                                    //         .selectedDay =
                                    //     appointment.appointmentDate;

                                    // Get.find<AppointmentBookingController>()
                                    //         .selectedTimeSlot =
                                    //     appointment.appointmentTime;

                                    // Get.find<AppointmentBookingController>()
                                    //         .appointmentId =
                                    //     appointment.id.toString();

                                    // Get.to(() => AppointmentBookingScreen(
                                    //       doctorId:
                                    //           appointment.patientId.toString(),
                                    //       isUpdate: true,
                                    //       isFromDoctor: true,
                                    //     ));
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
                                              SizedBox(
                                                  height: 45,
                                                  width: 45,
                                                  child: Image.asset(
                                                    'assets/person.png',
                                                    height: 22,
                                                  )),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.45,
                                                child: Text(
                                                    appointment.doctorName
                                                        .capitalizeFirst!,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black87)),
                                              ),
                                              const Spacer(),
                                              Container(
                                                height: 30,
                                                width: 80,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: () {
                                                    switch (
                                                        appointment.status) {
                                                      case 'Pending':
                                                        return ConstantThings
                                                            .accentColor;
                                                      case 'Cancelled':
                                                        return Colors
                                                            .red.shade400;
                                                      case 'Completed':
                                                        return Colors
                                                            .green.shade300;
                                                      case 'Scheduled':
                                                        return ConstantThings
                                                            .accentColor;
                                                      default:
                                                        return Colors
                                                            .grey.shade50;
                                                    }
                                                  }(),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  appointment.status,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
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
