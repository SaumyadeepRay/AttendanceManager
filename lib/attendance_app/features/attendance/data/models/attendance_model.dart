import '../../domain/entities/attendance.dart';

// AttendanceModel is a data model that extends the Attendance entity.
// It represents the data structure used for API communication and JSON serialization.

class AttendanceModel extends Attendance {
  // Constructor calls the parent constructor with necessary fields.
  AttendanceModel({
    required String employeeName,
    required String checkIn,
    required String checkOut,
    required String status,
  }) : super(
    employeeName: employeeName,
    checkIn: checkIn,
    checkOut: checkOut,
    status: status,
  );

  // Factory method to create an AttendanceModel object from JSON data.
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      employeeName: json['name'] ?? '', // Employee name from JSON data
      checkIn: json['checkIn'] ?? '', // Check-in time from JSON data
      checkOut: json['checkOut'] ?? '', // Check-out time from JSON data
      status: json['status'] ?? '', // Attendance status from JSON data
    );
  }

  // Converts the AttendanceModel object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': employeeName, // Employee name to JSON
      'checkIn': checkIn, // Check-in time to JSON
      'checkOut': checkOut, // Check-out time to JSON
      'status': status, // Attendance status to JSON
    };
  }
}
