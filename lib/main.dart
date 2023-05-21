import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nadi/src/service/database_service.dart';
import 'package:nadi/src/utils/material_swatch.dart';
<<<<<<< HEAD
import 'package:nadi/src/view/screens/patient_dashboard.dart';
import 'package:nadi/src/view/screens/welcome_screen.dart';
=======
import 'package:nadi/src/view/screens/signin_screen.dart';
>>>>>>> 7df190c9930a7d75e566f453be6e807b4f65beaf

void main() async {
  runApp(const MyApp());
  await DatabaseService.getConnection();
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
<<<<<<< HEAD
      home: WelcomeScreen(),
=======
      home: const SignInScreen(),
>>>>>>> 7df190c9930a7d75e566f453be6e807b4f65beaf
    );
  }
}
