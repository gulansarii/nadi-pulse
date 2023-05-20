import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nadi/src/viewmodel/create_account_viewmodel.dart';

import '../service/database_service.dart';

class LoginViewModel extends GetxController {
  final _username = ''.obs;
  final _password = ''.obs;

  String get username => _username.value;
  String get password => _password.value;

  void setUsername(String value) {
    _username.value = value;
  }

  void setPassword(String value) {
    _password.value = value;
  }

  Future<void> login() async {
    final connection = await DatabaseService.getConnection();

    try {
      await connection.open();

      final query =
          "SELECT * FROM users WHERE username = '${Get.find<CreateAccountViewModel>().usernameController.text}' AND password = '${Get.find<CreateAccountViewModel>().passwordController.text}'";
      final results = await connection.query(query);

      if (results.isEmpty) {
        print('Invalid credentials');
        Fluttertoast.showToast(msg: "Invalid credentials");
      } else {
        print('Login successful');
        Fluttertoast.showToast(msg: "Login Sucessfull");
      }
    } catch (error) {
      print("Connection failed!");
      print(error);
      Fluttertoast.showToast(msg: "Connection failed");
    } finally {
      await connection.close();
    }
  }
}
