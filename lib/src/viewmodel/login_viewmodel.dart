import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nadi/src/models/user_model.dart' as user_model;
import 'package:postgres/postgres.dart';

import '../service/database_service.dart';

class LoginViewModel extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late user_model.User loginUser;
  late PostgreSQLConnection connection;
  @override
  void onInit() async {
    connection = await DatabaseService.getConnection();
    super.onInit();
  }

  Future<void> login() async {
    try {
      final query =
          "SELECT * FROM users WHERE email = '${emailController.text}' AND password = '${passwordController.text}'";
      final results = await connection.query(query);
      print(results[0][0]);
      if (results.isEmpty) {
        print('Invalid credentials');
        Fluttertoast.showToast(msg: "Invalid credentials");
      } else {
        loginUser = user_model.User.fromMap({
          'id': results[0][1].toString(),
          'email': results[0][1].toString(),
          'password': results[0][2].toString(),
          'role': results[0][3].toString(),
          'name': results[0][4].toString(),
          'city': results[0][5].toString(),
          'state': results[0][6].toString(),
          'latitude': results[0][7] as double,
          'longitude': results[0][8] as double,
          'createdAt': results[0][9] as DateTime,
        });
        print(loginUser.city);
        print('Login successful');
        Fluttertoast.showToast(msg: "Login Sucessfull");
      }
    } catch (error) {
      print(error);
      Fluttertoast.showToast(msg: "Something went wrong ");
    }
  }
}
