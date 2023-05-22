import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nadi/src/viewmodel/login_viewmodel.dart';
import 'package:postgres/postgres.dart';
import 'package:nadi/src/models/user_model.dart' as user_model;

import '../../main.dart';
import '../service/database_service.dart';

class CreateAccountViewModel extends GetxController {
  RxBool isLoading = false.obs;
  late PostgreSQLConnection connection;
  late user_model.User loginUser;

  Future<bool> isEmailAlreadyExists(String email) async {
    final query = "SELECT * FROM users WHERE email = '$email'";
    final results = await connection.query(query);
    return results.isNotEmpty;
  }

  TextEditingController nameTextController =
      TextEditingController(text: "usaram");
  TextEditingController passwordTextController =
      TextEditingController(text: "123456");
  TextEditingController confirmPasswordTextController =
      TextEditingController(text: "123456");
  TextEditingController emailTextController =
      TextEditingController(text: "usaramwasi99@gmail.com");
  TextEditingController addressTextController = TextEditingController();
  bool isPatient = true;
  String latitude = "28.5355";
  String longitude = "77.3910";
  String city = "Noida";
  String state = "UP";
  String uuid = fcmToken;

  @override
  void onInit() async {
    connection = await DatabaseService.getConnection();
    super.onInit();
  }

  Future<void> createAccount() async {
    isLoading.value = true;

    try {
      // await connection.open();
      const createTableQuery = '''
      CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(1) NOT NULL,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    state VARCHAR(255) NOT NULL,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    location VARCHAR,
    createdAt TIMESTAMP DEFAULT current_timestamp,
    uuid VARCHAR
);
      ''';
      await connection.execute(createTableQuery);
      final isEmailExists =
          await isEmailAlreadyExists(emailTextController.text);
      if (isEmailExists) {
        print("Email already exists. User registration failed.");
        Fluttertoast.showToast(msg: "User already exists");

        return;
      }

      String hashedPassword =
          BCrypt.hashpw(passwordTextController.text, BCrypt.gensalt());

      var query = '''
  INSERT INTO users (email, password, role, name, city, state, latitude, longitude , location , uuid)
  VALUES (@email, @password, @role, @name, @city, @state, @latitude, @longitude , @location , @uuid)
''';
      final results = await connection.execute(query, substitutionValues: {
        'email': emailTextController.text,
        'password': hashedPassword,
        'role': isPatient ? 'P' : 'D',
        'name': nameTextController.text,
        'city': city,
        'state': state,
        'latitude': latitude,
        'longitude': longitude,
        'location': '$city, $state',
        'uuid': uuid
      });

      print(results);
      await Get.put(LoginViewModel()).setConnection();
      Get.find<LoginViewModel>()
          .login(emailTextController.text, passwordTextController.text);
      Fluttertoast.showToast(msg: "User registration successful");
    } catch (error) {
      Fluttertoast.showToast(msg: "User registration failed");
      print(error);
    } finally {
      isLoading.value = false;
    }
  }
}
