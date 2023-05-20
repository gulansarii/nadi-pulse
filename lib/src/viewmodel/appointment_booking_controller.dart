import 'package:get/get.dart';

class AppointmentBookingController extends GetxController {
  final days = List.filled(7, false);
  DateTime selectedDay = DateTime.now();
}
