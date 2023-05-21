import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nadi/src/view/screens/doctor_dashboard.dart';
import 'package:nadi/src/view/screens/patient_dashboard.dart';
import 'package:nadi/src/view/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? id;
  String? role ;

  // getDataFromSharedPref() async {}

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      id = prefs.getString('user_id');
      role = prefs.getString('role');
      print(id);

      if (id == null) {
        Get.offAll(() => const WelcomeScreen());
      } else {
        if (role == 'D') {
          Get.offAll(() => const DoctorDashboard());
        } else {
          Get.offAll(() => const PatientDashboard());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
            height: 200,
            width: 200,
            child: Image.asset(
                'assets/splash.png')), // Replace with your splash screen image
      ),
    );
  }
}
