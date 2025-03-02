import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/reusable_button.dart';
import '../../../../core/widgets/reusable_text_field.dart' show ReusableTextField;
import '../../domain/entities/attendance.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';

// This screen allows the admin to manage attendance records.
// It provides functionality to update attendance for employees.
class AttendanceManagementScreen extends StatefulWidget {
  const AttendanceManagementScreen({Key? key}) : super(key: key);

  @override
  _AttendanceManagementScreenState createState() =>
      _AttendanceManagementScreenState();
}

class _AttendanceManagementScreenState
    extends State<AttendanceManagementScreen> {
  final TextEditingController employeeNameController = TextEditingController();
  final TextEditingController checkInController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ReusableTextField(
                hintText: 'Employee Name', controller: employeeNameController),
            const SizedBox(height: 10),
            ReusableTextField(
                hintText: 'Check-In Time', controller: checkInController),
            const SizedBox(height: 10),
            ReusableTextField(
                hintText: 'Check-Out Time', controller: checkOutController),
            const SizedBox(height: 10),
            ReusableTextField(hintText: 'Status', controller: statusController),
            const SizedBox(height: 10),
            ReusableTextField(hintText: 'Date (e.g., YYYY-MM-DD)', controller: dateController),
            const SizedBox(height: 20),
            BlocConsumer<AttendanceBloc, AttendanceState>(
              listener: (context, state) {
                if (state is AttendanceUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Attendance Updated Successfully!')),
                  );
                  // Clear the text fields after successful update
                  employeeNameController.clear();
                  checkInController.clear();
                  checkOutController.clear();
                  statusController.clear();
                  dateController.clear();
                } else if (state is AttendanceError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is AttendanceLoading) {
                  return const CircularProgressIndicator();
                }
                return ReusableButton(
                  label: 'Update Attendance',
                  onPressed: () {
                    final attendance = Attendance(
                      employeeName: employeeNameController.text,
                      checkIn: checkInController.text,
                      checkOut: checkOutController.text,
                      status: statusController.text,
                      date: dateController.text, // Using the dateController text for the date
                    );
                    BlocProvider.of<AttendanceBloc>(context)
                        .add(UpdateAttendanceEvent(attendance));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    employeeNameController.dispose();
    checkInController.dispose();
    checkOutController.dispose();
    statusController.dispose();
    dateController.dispose(); // Dispose of the date controller as well
    super.dispose();
  }
}
