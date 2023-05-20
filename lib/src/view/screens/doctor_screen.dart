import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nadi/src/view/screens/availability_screen.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Availability:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const ManageAvailabilityScreen());
                // Navigate to the manage availability screen
              },
              child: const Text('Set Availability'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Manage Appointment Slots:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Navigate to the manage appointment slots screen
              },
              child: const Text('Manage Slots'),
            ),
          ],
        ),
      ),
    );
  }
}
