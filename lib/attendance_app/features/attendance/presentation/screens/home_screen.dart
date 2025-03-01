import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/reusable_button.dart';
import '../../../../core/widgets/reusable_loader.dart';
import '../../../employee/presentation/screens/employee_management_screen.dart';
import '../bloc/attendance_bloc.dart';
import '../../domain/entities/attendance.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';
import 'package:intl/intl.dart';

// HomeScreen displays the list of employee attendance records
// and provides an option to fetch and refresh attendance data.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;

  // Function to open Calendar Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Function to handle the manual update of Check-in/Check-out
  Future<void> _updateAttendance(
      BuildContext context, Attendance attendance) async {
    final TextEditingController checkInController =
    TextEditingController(text: attendance.checkIn);
    final TextEditingController checkOutController =
    TextEditingController(text: attendance.checkOut);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Attendance - ${attendance.employeeName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: checkInController,
                decoration: const InputDecoration(labelText: 'Check-In'),
              ),
              TextField(
                controller: checkOutController,
                decoration: const InputDecoration(labelText: 'Check-Out'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedAttendance = attendance.copyWith(
                  checkIn: checkInController.text,
                  checkOut: checkOutController.text,
                );
                BlocProvider.of<AttendanceBloc>(context)
                    .add(UpdateAttendanceEvent(updatedAttendance));
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Manager'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
            ),
            ListTile(
              title: const Text('Employees'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeManagementScreen()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Select Date',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ReusableButton(
              label: 'Fetch Attendance',
              onPressed: () {
                if (dateController.text.isNotEmpty) {
                  BlocProvider.of<AttendanceBloc>(context).add(FetchAttendanceEvent(dateController.text));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a date')),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<AttendanceBloc, AttendanceState>(
                builder: (context, state) {
                  if (state is AttendanceLoading) {
                    return const ReusableLoader();
                  }
                  if (state is AttendanceLoaded) {
                    return ListView.builder(
                      itemCount: state.attendances.length,
                      itemBuilder: (context, index) {
                        Attendance attendance = state.attendances[index];
                        String overtime = calculateOvertime(attendance.checkIn, attendance.checkOut);
                        return Card(
                          child: ListTile(
                            title: Text(attendance.employeeName),
                            subtitle: Text('Check-In: ${attendance.checkIn}, Check-Out: ${attendance.checkOut}, Overtime: $overtime'),
                            trailing: Text(attendance.status),
                            onTap: () => _updateAttendance(context, attendance),
                          ),
                        );
                      },
                    );
                  }
                  if (state is AttendanceError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('Select a date to fetch attendance'));
                },
              ),
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
      return difference.inHours > 9 ? '${difference.inHours - 9}h' : '0h';
    } catch (e) {
      return '0h';
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }
}
