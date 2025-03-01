import 'package:flutter/material.dart';
import '../../domain/entities/attendance.dart';

// AttendanceListItem is a reusable widget to display individual attendance records.
// It shows the employee name, check-in time, check-out time, and attendance status.
class AttendanceListItem extends StatelessWidget {
  final Attendance attendance; // Attendance entity to display data

  const AttendanceListItem({required this.attendance, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0, // Elevation for shadow effect
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), // Rounded corners
      child: ListTile(
        title: Text(
          attendance.employeeName, // Display employee name
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Check-In: ${attendance.checkIn}, Check-Out: ${attendance.checkOut}', // Display check-in and check-out times
        ),
        trailing: Chip(
          label: Text(
            attendance.status, // Display attendance status
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: attendance.status == 'Present' ? Colors.green : Colors.red, // Green for Present, Red for Absent
        ),
      ),
    );
  }
}