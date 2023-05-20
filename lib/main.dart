import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nadi/src/utils/material_swatch.dart';
import 'package:nadi/src/view/screens/doctor_dashboard.dart';
import 'package:nadi/src/view/screens/patient_dashboard.dart';
import 'package:nadi/src/view/screens/create_account_screen.dart';
import 'package:nadi/src/view/screens/signin_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: createMaterialColor(const Color(0xFFa1d6c9)),
      ),
      home: DoctorDashboard(),
    );
  }
}
