import 'package:get/get.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../models/appointments_model.dart';
import '../models/user_model.dart';

class PatientDashBoardViewModel extends GetxController {
  String patient_id = "";
  String latitude = "";
  String longitude = "";
  RxBool isLoading = true.obs;
  RxBool isAppointmentLoading = true.obs;
  RxString loggedInUserName = "".obs;
  RxList<User> userList = <User>[].obs;
  RxList<Appointment> appointmentList = <Appointment>[].obs;

  late PostgreSQLConnection connection = postgreSQLConnection;

  // get patient id from shared preference
  getPatientid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    patient_id = prefs.getString("user_id")!;
    latitude = prefs.getString("latitude")!;
    longitude = prefs.getString("longitude")!;
    loggedInUserName.value = prefs.getString("name")!;
    print("patient_id $patient_id");
    print("latitude $latitude");
    print("longitude $longitude");
  }

  setConnection() async {
    // print("set connection");
    // connection = await DatabaseService.getConnection();
    // print(connection.isClosed);
  }

  getAllDoctorList() async {
    isLoading.value = true;

    try {
      var query = '''
    SELECT *
    FROM users
    WHERE role = 'D'
      AND earth_distance(
          ll_to_earth(latitude, longitude),
          ll_to_earth(@userLatitude, @userLongitude)
        ) < 10000000
  ''';

      final substitutionValues = {
        'userLatitude': latitude,
        'userLongitude': longitude,
      };
      List<List<dynamic>> results =
          await connection.query(query, substitutionValues: substitutionValues);

      //     List<List<dynamic>> results = await connection.query('''
      //   SELECT * FROM users
      //   WHERE role = 'D'
      // ''');
      // print(results);
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
          createdAt: row[10] as DateTime,
          location: row[9].toString(),
          uuid: row[11].toString(),
        );
        userList.add(user);
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: "Error in fetching data");
      print(e);
    } finally {
      print(userList.length);
      isLoading.value = false;
    }
  }

  getAllDoctorSearchedList(String word) async {
    isLoading.value = true;

    try {
      var query = '''
      SELECT * FROM users WHERE role = 'D' AND location ILIKE '%$word%';
    ''';

    List<List<dynamic>> results = await connection.query(query);
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
          createdAt: row[10] as DateTime,
          location: row[9].toString(),
          uuid: row[11].toString(),
        );
        userList.add(user);
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: "Error in fetching data");
      print(e);
    } finally {
      print(userList.length);
      isLoading.value = false;
    }
  }




  getAllAppointments() async {
    isAppointmentLoading.value = true;
    try {
      await connection.execute('''
UPDATE appointments
SET status = 'Completed'
WHERE appointment_date < CURRENT_DATE
  AND status <> 'Completed';
''');
      List<List<dynamic>> results = await connection.query('''
  SELECT a.*, u.name AS doctor_name , u.uuid AS fcm_token
FROM appointments AS a
JOIN users AS u ON a.doctor_id = u.id
WHERE a.patient_id = '$patient_id'
  ORDER BY appointment_date ASC;

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
          'doctor_name': row[6].toString(),
          'fcm_token': row[7].toString(),
        });
        appointmentList.add(appointment);
      }
      print(appointmentList.length);
    } catch (e) {
      // Fluttertoast.showToast(msg: "Error in fetching data");
      print(e);
    } finally {
      isAppointmentLoading.value = false;
    }
  }
}
