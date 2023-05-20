import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:postgres/postgres.dart';
import '../service/database_service.dart';

class CreateAccountViewModel extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late PostgreSQLConnection connection;

  @override
  void onInit() async {
    super.onInit();
    connection = await DatabaseService.getConnection();
  }

  // Function to check if email already exists
  Future<bool> isEmailAlreadyExists(String email) async {
    final query = "SELECT * FROM users WHERE email = '$email'";
    final results = await connection.query(query);
    return results.isNotEmpty;
  }



  Future<void> createAccount() async {
    try {
      await connection.open();
      final isEmailExists = await isEmailAlreadyExists(usernameController.text);
      if (isEmailExists) {
        print("Email already exists. User registration failed.");
        return;
      }
      const createTableQuery = '''
        CREATE TABLE IF NOT EXISTS users (
          id SERIAL PRIMARY KEY,
          username VARCHAR(255) NOT NULL,
          password VARCHAR(255) NOT NULL,
          role VARCHAR(1) NOT NULL
        )
      ''';

      await connection.execute(createTableQuery);
      final query =
          "INSERT INTO users (email, password, role) VALUES ('${usernameController.text}', '${passwordController.text}', 'P')";
      await connection.execute(query);
      Fluttertoast.showToast(msg: "User registered successfully");
    } catch (error) {
      Fluttertoast.showToast(msg: "User registration failed");
      print(error);
    } finally {
      await connection.close();
    }
  }
}
