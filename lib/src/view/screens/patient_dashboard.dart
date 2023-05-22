import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nadi/src/utils/constants.dart';
import 'package:nadi/src/view/screens/appointment_booking_screen.dart';
import 'package:nadi/src/view/screens/nearest_doctor_screen.dart';
import 'package:nadi/src/view/screens/splash_screen.dart';
import 'package:nadi/src/viewmodel/patient_dashboad_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../viewmodel/appointment_booking_controller.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<PatientDashboard> {
  PatientDashBoardViewModel patientDashBoardViewModel =
      Get.put(PatientDashBoardViewModel());
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

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
      key: _key,
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
                      patientDashBoardViewModel.loggedInUserName.value
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
      //  appBar: AppBar(
      //     backgroundColor: Colors.transparent,
      //     title: const Text('Patient Dashboard'),
      //     // centerTitle: true,
      //   ),
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: () async {
          await patientDashBoardViewModel.getAllDoctorList();
          await patientDashBoardViewModel.getAllAppointments();
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    height: (Get.height * 0.4) + 50,
                    width: Get.width,
                    child: Stack(
                      children: [
                        Container(color: ConstantThings.accentColor),
                        InkWell(
                          onTap: () {
                            _key.currentState!.openDrawer();
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 50, left: 20),
                            child: CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    AssetImage('assets/doctor.png')),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 130, left: 20),
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(text: 'Expert\n'),
                                TextSpan(
                                  text: 'Consultation\n',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Doctors online consultation \n',
                                  children: [],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white54,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Positioned(
                          top: Get.height * 0.06,
                          left: Get.width * 0.4,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Image.network(
                              'https://aahantechnologies.com/imgDemo/doc-img21.png',
                              fit: BoxFit.contain,
                              height: Get.height * 0.27,
                              width: Get.width * 0.8,
                            ),
                          ),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
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
                                    TextButton(
                                      onPressed: () {
                                        Get.to(
                                            () => const NearestDoctorScreen());
                                      },
                                      child: const Text(
                                        "See All",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                height: 100,
                width: Get.width,
                child: Obx(() => patientDashBoardViewModel.isLoading.value
                    ? SizedBox(
                        width: Get.width,
                        child: const Center(child: CircularProgressIndicator()))
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
                                    Get.put(AppointmentBookingController())
                                        .doctorFcm = doctor.uuid!;
                                    Get.to(() => AppointmentBookingScreen(
                                          doctorId: doctor.id,
                                          isUpdate: false,
                                          isFromDoctor: false,
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
                                      SizedBox(
                                        child: Text(
                                          "${doctor.name} hdhd dh hdhd hd ",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
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
                  child: Row(
                    children: [
                      Text(
                        "My Appointments",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                      ? SizedBox(
                          height: Get.height * 0.3,
                          child:
                              const Center(child: CircularProgressIndicator()))
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
                              // reverse: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
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

                                      if (appointment.status == "Cancelled" ||
                                          appointment.status == "Completed") {
                                        Fluttertoast.showToast(
                                          msg:
                                              "You can't update past appointment",
                                        );
                                        return;
                                      }

                                      Get.put(AppointmentBookingController())
                                              .selectedDay =
                                          appointment.appointmentDate;

                                      Get.find<AppointmentBookingController>()
                                              .selectedTimeSlot =
                                          appointment.appointmentTime;

                                      Get.find<AppointmentBookingController>()
                                              .appointmentId =
                                          appointment.id.toString();

                                      Get.find<AppointmentBookingController>()
                                          .doctorFcm = appointment.fcmToken!;

                                      Get.to(() => AppointmentBookingScreen(
                                            doctorId:
                                                appointment.doctorId.toString(),
                                            isUpdate: true,
                                            isFromDoctor: false,
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
                                                Text(
                                                    appointment.doctorName
                                                        .capitalizeFirst!,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black87)),
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
                                                              .accentColor
                                                              .withOpacity(0.7);
                                                        case 'Cancelled':
                                                          return Colors
                                                              .red.shade400;
                                                        case 'Scheduled':
                                                          return ConstantThings
                                                              .accentColor;
                                                        case 'Completed':
                                                          return Colors
                                                              .green.shade300;
                                                        default:
                                                          return Colors
                                                              .grey.shade50;
                                                      }
                                                    }(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
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
      ),
    );
  }
}

//  Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration:
//                   const BoxDecoration(color: ConstantThings.accentColor),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const CircleAvatar(
//                       radius: 30,
//                       backgroundImage: AssetImage('assets/doctor.png')),
//                   const SizedBox(height: 10),
//                   Obx(
//                     () => Text(
//                       patientDashBoardViewModel.loggedInUserName.value
//                           .toString(),
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Logout'),
//               onTap: () async {
//                 await Get.deleteAll();
//                 SharedPreferences prefs = await SharedPreferences.getInstance();
//                 prefs.clear();
//                 Get.back();
//                 Get.offAll(() => const SplashScreen());
//               },
//             ),
//           ],
//         ),
//       ),
