import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nadi/src/service/database_service.dart';
import 'package:nadi/src/utils/material_swatch.dart';
import 'package:nadi/src/view/screens/signin_screen.dart';

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
      title: 'Nadi Pulse',
      theme: ThemeData(
        primarySwatch: createMaterialColor(const Color(0xFFa1d6c9)),
      ),
      // home:  const SplashScreen(),
      home: const SignInScreen(),
    );
  }
}
