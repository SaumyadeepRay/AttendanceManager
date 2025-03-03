import 'package:flutter/material.dart';
import '../../domain/entities/attendance.dart';
import 'package:intl/intl.dart';

class AttendanceListItem extends StatelessWidget {
  final Attendance attendance;
  final VoidCallback onUpdate;

  const AttendanceListItem({
    required this.attendance,
    required this.onUpdate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String overtime = calculateOvertime(attendance.checkIn, attendance.checkOut);

    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        title: Text(
          attendance.employeeName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Check-In: ${attendance.checkIn}, Check-Out: ${attendance.checkOut}, Overtime: $overtime',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(
                attendance.status,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: attendance.status == 'Present' ? Colors.green : Colors.red,
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onUpdate,
            ),
          ],
        ),
      ),
    );
  }

  String calculateOvertime(String checkIn, String checkOut) {
    try {
      DateTime inTime = DateTime.parse('2025-03-01T$checkIn');
      DateTime outTime = DateTime.parse('2025-03-01T$checkOut');
      Duration difference = outTime.difference(inTime);

      if (difference.inMinutes > (9 * 60)) {
        int overtimeMinutes = difference.inMinutes - (9 * 60);
        int hours = overtimeMinutes ~/ 60;
        int minutes = overtimeMinutes % 60;
        return '${hours}h ${minutes}m';
      }
      return '0h 0m';
    } catch (e) {
      return '0h 0m';
    }
  }
}