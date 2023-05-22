class Appointment {
  final int id;
  final int doctorId;
  final int patientId;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String status;
  final String doctorName;
   String? fcmToken;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    required this.doctorName,
    required this.fcmToken,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] as int,
      doctorId: map['doctor_id'] as int,
      patientId: map['patient_id'] as int,
      appointmentDate: map['appointment_date'] as DateTime,
      appointmentTime: map['appointment_time'] as String,
      status: map['status'] as String,
      doctorName: map['doctor_name'] as String,
      fcmToken: map['fcm_token'] ?? "",
    );
  }
}
