import 'package:get/get.dart';
import 'package:nadi/src/models/appointments_model.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/database_service.dart';

class DoctorDashboardController extends GetxController {
  String doctorId = "";
  String latitude = "";
  String longitude = "";
  RxBool isLoading = false.obs;
  RxBool isAppointmentLoading = false.obs;
  late PostgreSQLConnection connection;
  RxList<Appointment> pastAppointmentList = <Appointment>[].obs;

  RxList<Appointment> upcomingAppointmentList = <Appointment>[].obs;
  getPatientid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    doctorId = prefs.getString("user_id")!;
  }

  setConnection() async {
    print("set connection");
    connection = await DatabaseService.getConnection();
    print(connection.isClosed);
  }

  getUpcomingAppointments() async {
    isAppointmentLoading.value = true;
    try {
      await connection.execute('''
UPDATE appointments
SET status = 'Completed'
WHERE appointment_date < CURRENT_DATE
  AND status <> 'Completed';
''');
      List<List<dynamic>> results = await connection.query('''

SELECT appointments.*, users.name AS patient_name
FROM appointments
JOIN users ON appointments.patient_id = users.id
WHERE appointments.doctor_id = '$doctorId'
  AND (appointments.status = 'Pending' OR appointments.status = 'Scheduled')
ORDER BY appointment_date ASC;

  ''');
      upcomingAppointmentList.value = [];
      // print("results $results");
      for (final row in results) {
        final appointment = Appointment.fromMap({
          'id': row[0] as int,
          'doctor_id': row[1] as int,
          'patient_id': row[2] as int,
          'appointment_date': row[3] as DateTime,
          'appointment_time': row[4].toString(),
          'status': row[5].toString(),
          'doctor_name': row[6].toString(),
        });
        upcomingAppointmentList.add(appointment);
      }
      print(upcomingAppointmentList.length);
    } catch (e) {
      print(e);
    } finally {
      isAppointmentLoading.value = false;
    }
  }

  getPastAppointments() async {
    isAppointmentLoading.value = true;
    try {
      await connection.execute('''
UPDATE appointments
SET status = 'Completed'
WHERE appointment_date < CURRENT_DATE
  AND status <> 'Completed';
''');
      List<List<dynamic>> results = await connection.query('''
SELECT appointments.*, users.name AS patient_name
FROM appointments
JOIN users ON appointments.patient_id = users.id
WHERE appointments.doctor_id = '$doctorId'
  AND (appointments.status = 'Cancelled' OR appointments.status = 'Completed')
  ORDER BY appointment_date ASC;
  ''');
      pastAppointmentList.value = [];
      for (final row in results) {
        final appointment = Appointment.fromMap({
          'id': row[0] as int,
          'doctor_id': row[1] as int,
          'patient_id': row[2] as int,
          'appointment_date': row[3] as DateTime,
          'appointment_time': row[4].toString(),
          'status': row[5].toString(),
          'doctor_name': row[6].toString(),
        });
        pastAppointmentList.add(appointment);
      }
    } catch (e) {
      print(e);
    } finally {
      isAppointmentLoading.value = false;
    }
  }

  acceptAppointment(int appointmentId) async {
    try {
      await connection.execute('''
      UPDATE appointments
      SET status = 'Scheduled'
      WHERE id = $appointmentId;
    ''');
      await getUpcomingAppointments();
    } catch (e) {
      print('Error accepting appointment: $e');
    }
  }

  rejectAppointment(int appointmentId) async {
    try {
      await connection.execute('''
      UPDATE appointments
      SET status = 'Cancelled'
      WHERE id = $appointmentId;
    ''');
      await getUpcomingAppointments();
      await getPastAppointments();
    } catch (e) {
      print('Error rejecting appointment: $e');
    }
  }
}
