import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nadi/src/service/notification_service.dart';
import 'package:nadi/src/viewmodel/doctor_dashboard_controller.dart';
import 'package:nadi/src/viewmodel/patient_dashboad_viewmodel.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class AppointmentBookingController extends GetxController {
  RxBool isBookLoading = false.obs;
  bool isFromDoctor = false;
  DateTime selectedDay = DateTime.now();
   PostgreSQLConnection connection = postgreSQLConnection;
  String selectedTimeSlot = "";
  String doctorId = "";
  String patientId = "";
  bool isUpdate = false;
  String appointmentId = "";
  String doctorFcm = "";
  String loggedInUserName = "";
  var formatedofDate = DateFormat('dd MMM yyyy');
  // String formattedDate = formatedofDate.format(selectedDay.appointmentDate);

  getPatientid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    patientId = prefs.getString("user_id")!;
  }

  setConnection() async {
    // connection = await DatabaseService.getConnection();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedInUserName = prefs.getString("name")!;
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
        isBookLoading.value = true;


    try {
      const createTableQuery = '''
      CREATE TABLE IF NOT EXISTS appointments (
        id SERIAL PRIMARY KEY,
        doctor_id INT NOT NULL,
        patient_id INT NOT NULL,
        appointment_date TIMESTAMP WITH TIME ZONE NOT NULL,
        appointment_time VARCHAR(100) NOT NULL,
        status VARCHAR(255) NOT NULL DEFAULT 'Pending',
        FOREIGN KEY (doctor_id) REFERENCES users (id),
        FOREIGN KEY (patient_id) REFERENCES users (id)
      )
    ''';

      await connection.query(createTableQuery);

      // Check if appointment already exists
      final isExits = await isAppointmentExistForDate(selectedDay);

      if (isExits) {
        Fluttertoast.showToast(
            msg: "Appointment already exists for the selected date");
        return;
      }
      await connection.query('''
      INSERT INTO appointments (doctor_id, patient_id, appointment_date, appointment_time)
      VALUES (@doctorId, @patientId, @selectedDate, @selectedTimeSlot)
    ''', substitutionValues: {
        'doctorId': doctorId,
        'patientId': patientId,
        'selectedDate': selectedDay,
        'selectedTimeSlot': selectedTimeSlot,
      });

      print("doctorId $doctorId");
      print("patientId $patientId");
      print("selectedDate $selectedDay");
      print("selectedTimeSlot $selectedTimeSlot");

      // print(result);
      print("doctorFcm $doctorFcm");

      Get.find<PatientDashBoardViewModel>().getAllAppointments();
      Fluttertoast.showToast(msg: "Appointment booked successfully");
      NotificationService.showNotification(
          title: "Appointment Booked",
          message:
              "${loggedInUserName.capitalizeFirst} book appoinment for ${formatedofDate.format(selectedDay)}",
          fcmToken: doctorFcm);

      Get.back();
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
      print('Error creating/updating appointment: $e');
    }
    finally{
      isBookLoading.value = false;
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

      if (isFromDoctor) {
        Get.find<DoctorDashboardController>().getUpcomingAppointments();
        Get.find<DoctorDashboardController>().getPastAppointments();
      } else {
        Get.find<PatientDashBoardViewModel>().getAllAppointments();
      }
         NotificationService.showNotification(
          title: "Appointment Updated",
          message:
              "${loggedInUserName.capitalizeFirst} update appoinment for ${formatedofDate.format(selectedDay)}",
          fcmToken: doctorFcm);
      Fluttertoast.showToast(msg: "Appointment updated successfully");

      Get.back();
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
      print('Error updating appointment: $e');
    }
  }

  Future<void> cancelAppointment() async {
    try {
      final result = await connection.query('''
      UPDATE appointments
      SET status = 'Cancelled'
      WHERE id = @appointmentId
    ''', substitutionValues: {'appointmentId': appointmentId});

      if (result.affectedRowCount > 0) {
        if (isFromDoctor) {
          Get.find<DoctorDashboardController>().getUpcomingAppointments();
          Get.find<DoctorDashboardController>().getPastAppointments();
        } else {
          Get.find<PatientDashBoardViewModel>().getAllAppointments();
        }

        Get.back();
        NotificationService.showNotification(
            title: "Appointment Booked",
            message:
                "${loggedInUserName.capitalizeFirst} cancel appoinment for ${formatedofDate.format(selectedDay)}",
            fcmToken: doctorFcm);
        Fluttertoast.showToast(msg: "Appointment cancelled successfully");
      } else {
        Fluttertoast.showToast(msg: "Failed to cancel appointment");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
      print('Error canceling appointment: $e');
    }
  }
}
