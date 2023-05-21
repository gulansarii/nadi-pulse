import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nadi/src/models/user_model.dart' as user_model;
import 'package:nadi/src/view/screens/doctor_dashboard.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/database_service.dart';
import '../view/screens/patient_dashboard.dart';

class LoginViewModel extends GetxController {
  TextEditingController emailController = TextEditingController(text: "usaramwasi99@gmail.com");
  TextEditingController passwordController = TextEditingController(text: "123456");

  late user_model.User loginUser;
  late PostgreSQLConnection connection;

  setConnection()async{
    connection = await DatabaseService.getConnection();
  }
  @override
  void onInit() async {
    connection = await DatabaseService.getConnection();
    super.onInit();
  }

  Future<void> login(String email, String pass) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final query =
          "SELECT * FROM users WHERE email = '$email' AND password = '$pass'";
      final results = await connection.query(query);
      if (results.isEmpty) {
        print('Invalid credentials');
        Fluttertoast.showToast(msg: "Invalid credentials");
      } else {
        print(results[0][11].toString());
        loginUser = user_model.User.fromMap({
          'id': results[0][0].toString(),
          'email': results[0][1].toString(),
          'password': results[0][2].toString(),
          'role': results[0][3].toString(),
          'name': results[0][4].toString(),
          'city': results[0][5].toString(),
          'state': results[0][6].toString(),
          'latitude': results[0][7] as double,
          'longitude': results[0][8] as double,
          'location' : results[0][9].toString(),
          'createdAt': results[0][10] as DateTime,
          'uuid': results[0][11].toString(),
        });
        print(results);
        print('Login successful');
        prefs.setString("user_id", loginUser.id);
        prefs.setString("role", loginUser.role);
        prefs.setString("latitude", loginUser.latitude.toString());
        prefs.setString("longitude", loginUser.longitude.toString());
        Fluttertoast.showToast(msg: "Login Sucessfull");
        if (loginUser.role == "P") {
          Get.offAll(() => const PatientDashboard());
        } 
        else {
          Get.offAll(() => const DoctorDashboard());
        }
      }
    } catch (error) {
      print(error);
      Fluttertoast.showToast(msg: "Something went wrong ");
    }
  }
}
