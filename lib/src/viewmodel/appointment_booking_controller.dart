import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nadi/src/viewmodel/patient_dashboad_viewmodel.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/database_service.dart';

class AppointmentBookingController extends GetxController {
  DateTime selectedDay = DateTime.now();
  late PostgreSQLConnection connection;
  String selectedTimeSlot = "";
  String doctorId = "";
  String patientId = "";
  bool isUpdate = false;
  String appointmentId = "";

  getPatientid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    patientId = prefs.getString("user_id")!;
    // print("patient_id $patientId");
  }

  setConnection() async {
    connection = await DatabaseService.getConnection();
    print(connection.isClosed);
  }

  // appointment already exist for selected date
  Future<bool> isAppointmentExistForDate(DateTime selectedDate) async {
    try {
      final results = await connection.query('''
      SELECT COUNT(*) FROM appointments
      WHERE appointment_date = @selectedDate
    ''', substitutionValues: {'selectedDate': selectedDate});
      final count = results.first.first as int;
      return count > 0;
    } catch (e) {
      print('Error checking appointment existence: $e');
      return false;
    }
  }

  bookAppointment() async {
    if (selectedTimeSlot == "") {
      Fluttertoast.showToast(msg: "Please select a time slot");
      return;
    }

    // Check if appointment already exists
    final isAppointmentExist = await isAppointmentExistForDate(selectedDay);
    if (isAppointmentExist) {
      Fluttertoast.showToast(msg: "Appointment already exists");
      return;
    }

    try {
      const createTableQuery = '''
      CREATE TABLE IF NOT EXISTS appointments (
        id SERIAL PRIMARY KEY,
        doctor_id INT NOT NULL,
        patient_id INT NOT NULL,
        appointment_date TIMESTAMP WITH TIME ZONE NOT NULL,
        appointment_time VARCHAR(100) NOT NULL,
        status VARCHAR(255) NOT NULL DEFAULT 'Scheduled',
        FOREIGN KEY (doctor_id) REFERENCES users (id),
        FOREIGN KEY (patient_id) REFERENCES users (id)
      )
    ''';

      await connection.query(createTableQuery);
      await connection.query('''
      INSERT INTO appointments (doctor_id, patient_id, appointment_date, appointment_time)
      VALUES (@doctorId, @patientId, @selectedDate, @selectedTimeSlot)
    ''', substitutionValues: {
        'doctorId': doctorId,
        'patientId': patientId,
        'selectedDate': selectedDay,
        'selectedTimeSlot': selectedTimeSlot,
      });

      // print(result);

      Fluttertoast.showToast(msg: "Appointment booked successfully");
      Get.find<PatientDashBoardViewModel>().getAllAppointments();
      Get.back();
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
      print('Error creating/updating appointment: $e');
    }
  }

  Future<void> updateAppointment() async {
    try {
      final isExits = await isAppointmentExistForDate(selectedDay);

      if (isExits) {
        Fluttertoast.showToast(
            msg: "Appointment already exists for the selected date");
        return;
      }

      await connection.query('''
      UPDATE appointments
      SET appointment_date = @newDate,
          appointment_time = @newTimeSlot
      WHERE id = @appointmentId
    ''', substitutionValues: {
        'newDate': selectedDay,
        'newTimeSlot': selectedTimeSlot,
        'appointmentId': appointmentId,
      });
      Fluttertoast.showToast(msg: "Appointment updated successfully");

      Get.find<PatientDashBoardViewModel>().getAllAppointments();
      Get.back();
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
      print('Error updating appointment: $e');
    }
  }

  Future<void> cancelAppointment() async {
  try {
    await connection.query('''
      DELETE FROM appointments
      WHERE id = @appointmentId
    ''', substitutionValues: {
      'appointmentId': appointmentId,
    });

    Fluttertoast.showToast(msg: "Appointment canceled successfully");
  } catch (e) {
    Fluttertoast.showToast(msg: "Something went wrong");
    print('Error canceling appointment: $e');
  }
}

}
