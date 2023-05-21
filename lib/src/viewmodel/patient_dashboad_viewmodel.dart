import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nadi/src/service/database_service.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/appointments_model.dart';
import '../models/user_model.dart';

class PatientDashBoardViewModel extends GetxController {
  String patient_id = "";
  RxBool isLoading = false.obs;
  RxBool isAppointmentLoading = false.obs;

  RxList<User> userList = <User>[].obs;
  RxList<Appointment> appointmentList = <Appointment>[].obs;

  late PostgreSQLConnection connection;

  // get patient id from shared preference
  getPatientid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    patient_id = prefs.getString("user_id")!;
    print("patient_id $patient_id");
  }

  setConnection() async {
    print("set connection");
    connection = await DatabaseService.getConnection();
    print(connection.isClosed);
  }

  getAllDoctorList() async {
    isLoading.value = true;

    try {
      List<List<dynamic>> results = await connection.query('''
    SELECT * FROM users
    WHERE role = 'D'
  ''');
      userList.value = [];
      for (final row in results) {
        final user = User(
          id: row[0].toString(),
          email: row[1].toString(),
          password: row[2].toString(),
          role: row[3].toString(),
          name: row[4].toString(),
          city: row[5].toString(),
          state: row[6].toString(),
          latitude: row[7] as double,
          longitude: row[8] as double,
          createdAt: row[9] as DateTime,
        );
        userList.add(user);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error in fetching data");
      print(e);
    } finally {
      print(userList.length);
      isLoading.value = false;
    }
  }

  getAllAppointments() async {
    isAppointmentLoading.value = true;
    try {
      List<List<dynamic>> results = await connection.query('''
  SELECT a.*, u.name AS doctor_name
FROM appointments AS a
JOIN users AS u ON a.doctor_id = u.id
WHERE a.patient_id = '$patient_id';
  ''');
      appointmentList.value = [];
      print(results);
      for (final row in results) {
        final appointment = Appointment.fromMap({
          'id': row[0] as int,
          'doctor_id': row[1] as int,
          'patient_id': row[2] as int,
          'appointment_date': row[3] as DateTime,
          'appointment_time': row[4].toString(),
          'status': row[5].toString(),
          'doctor_name': row[7].toString(),
        });
        appointmentList.add(appointment);
      }
      print(appointmentList.length);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error in fetching data");
      print(e);
    } finally {
      isAppointmentLoading.value = false;
    }
  }
}
