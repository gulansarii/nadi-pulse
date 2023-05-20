import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:nadi/src/view/screens/appointment_booking_screen.dart';
import 'package:nadi/src/viewmodel/nearest_doctor_controller.dart';

class NearestDoctorScreen extends StatefulWidget {
  const NearestDoctorScreen({super.key});

  @override
  State<NearestDoctorScreen> createState() => _NearestDoctorScreenState();
}

class _NearestDoctorScreenState extends State<NearestDoctorScreen> {
  final NearestDoctorController nearestDoctorController =
      Get.put(NearestDoctorController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        title: Obx(
          () => Row(
            children: [
              nearestDoctorController.isSearchEnable.value
                  ? Text(
                      "Nearest Doctors",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  : SizedBox(
                      height: 30,
                      width: Get.width / 1.5,
                      child: TextField(
                        controller: nearestDoctorController.searchController,
                        decoration: InputDecoration(
                            isDense: true,
                            hintText: "Search",
                            hintStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            border: UnderlineInputBorder()),
                      )),
              Spacer(),
              GestureDetector(
                onTap: () {
                  nearestDoctorController.isSearchEnable.value =
                      !nearestDoctorController.isSearchEnable.value;
                },
                child: !nearestDoctorController.isSearchEnable.value
                    ? Icon(Icons.close)
                    : Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                            height: 70,
                            width: 70,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 1, color: Colors.grey.shade100),
                            ),
                            child: Image.asset(
                              'assets/doctor.png',
                              height: 40,
                            )),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Dr. John Doe",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Okhla, New Delhi",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => AppointmentBookingScreen());
                          },
                          child: Container(
                            height: 30,
                            width: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "Book Now",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}