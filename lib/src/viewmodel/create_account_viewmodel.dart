import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:postgres/postgres.dart';
import 'package:nadi/src/models/user_model.dart' as user_model;

import '../service/database_service.dart';

class CreateAccountViewModel extends GetxController {
  
  late PostgreSQLConnection connection;
  late user_model.User loginUser;

  Future<bool> isEmailAlreadyExists(String email) async {
    final query = "SELECT * FROM users WHERE email = '$email'";
    final results = await connection.query(query);
    return results.isNotEmpty;
  }

  TextEditingController nameTextController = TextEditingController(text: "usaram");
  TextEditingController passwordTextController = TextEditingController(text: "123456");
  TextEditingController confirmPasswordTextController = TextEditingController(text: "123456");
  TextEditingController emailTextController = TextEditingController(text: "usaramwasi99@gmail.com");
  TextEditingController addressTextController = TextEditingController();
  bool isPatient = true;
  String latitude = "222";
  String longitude = "222";
  String city = "22";
  String state = "222";

    @override
  void onInit() async {
    connection = await DatabaseService.getConnection();
    super.onInit();
  }

  Future<void> createAccount() async {
    try {
      // await connection.open();
      final isEmailExists = await isEmailAlreadyExists(emailTextController.text);
      if (isEmailExists) {
        print("Email already exists. User registration failed.");
              Fluttertoast.showToast(msg: "User already exists");

        return;
      }
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
    createdAt TIMESTAMP DEFAULT current_timestamp
);
      ''';

       await connection.execute(createTableQuery);
  var query = '''
  INSERT INTO users (email, password, role, name, city, state, latitude, longitude)
  VALUES (@email, @password, @role, @name, @city, @state, @latitude, @longitude)
''';
final results = await connection.execute(query, substitutionValues: {
  'email': emailTextController.text,
  'password': passwordTextController.text,
  'role': isPatient ? 'P' : 'D',
  'name': nameTextController.text,
  'city': city,
  'state': state,
  'latitude': latitude,
  'longitude': longitude,
});
      print(results);
      Fluttertoast.showToast(msg: "User registered ");
    } catch (error) {
      Fluttertoast.showToast(msg: "User registration failed");
      print(error);
    }
  }
}
