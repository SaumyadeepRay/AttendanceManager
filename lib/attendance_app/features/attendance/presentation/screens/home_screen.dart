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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController checkInController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();
  final TextEditingController employeeNameController = TextEditingController();
  final TextEditingController datePopupController = TextEditingController();
  DateTime? selectedDate;

  bool _isFormValid() {
    return employeeNameController.text.isNotEmpty &&
        datePopupController.text.isNotEmpty &&
        checkInController.text.isNotEmpty &&
        checkOutController.text.isNotEmpty;
  }

  // Automatically fetch the data when a date is selected
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

  // Fixed the _selectPopupDate method to update the correct controller
  Future<void> _selectPopupDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        datePopupController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(picked); // Update the popup date
      });
    }
  }

  // Time picker function for selecting check-in and check-out times
  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
    Function setStateDialog,
    Function setStateParent,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final DateTime selectedDateTime = DateTime(
        0,
        0,
        0,
        picked.hour,
        picked.minute,
      );
      controller.text = DateFormat('HH:mm').format(selectedDateTime);
      setStateDialog(() {}); // Rebuild the dialog
      setStateParent(() {}); // Rebuild parent to revalidate form
    }
  }

  // Method to save the attendance
  Future<void> _saveAttendance(BuildContext context) async {
    if (_isFormValid()) {
      final newAttendance = Attendance(
        date: datePopupController.text,
        employeeName: employeeNameController.text,
        checkIn: checkInController.text,
        checkOut: checkOutController.text,
        status: 'Present',
      );

      BlocProvider.of<AttendanceBloc>(
        context,
      ).add(UpdateAttendanceEvent(newAttendance));

      // Clear Form Fields After Saving
      employeeNameController.clear();
      datePopupController.clear();
      checkInController.clear();
      checkOutController.clear();

      // Close Dialog
      Navigator.of(context).pop();
    }
  }

  Future<void> saveOrUpdateAttendance(Attendance attendance) async {
    try {
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulating an async call
      print('Attendance saved or updated: ${attendance.employeeName}');
    } catch (error) {
      print('Error saving/updating attendance: $error');
    }
  }

  // Show a dialog to update or add attendance data
  Future<void> _updateAttendance(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Add or Update Attendance'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: employeeNameController,
                      decoration: const InputDecoration(
                        labelText: 'Employee Name',
                      ),
                      onChanged: (value) {
                        setState(() {}); // Update form validity in parent
                        setStateDialog(() {}); // Trigger rebuild of the dialog
                      },
                    ),
                    TextField(
                      controller: datePopupController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Select Date',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () {
                            _selectPopupDate(context);
                            setState(() {}); // Update form validity in parent
                            setStateDialog(() {});
                          },
                        ),
                      ),
                      onTap: () {
                        _selectPopupDate(context);
                        setState(() {}); // Update form validity in parent
                        setStateDialog(() {});
                      },
                    ),
                    TextField(
                      controller: checkInController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Check-In Time',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () {
                            _selectTime(
                              context,
                              checkInController,
                              setStateDialog,
                              setState,
                            ); // Pass setState
                          },
                        ),
                      ),
                      onTap: () {
                        _selectTime(
                          context,
                          checkInController,
                          setStateDialog,
                          setState,
                        ); // Pass setState
                      },
                    ),
                    TextField(
                      controller: checkOutController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Check-Out Time',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () {
                            _selectTime(
                              context,
                              checkOutController,
                              setStateDialog,
                              setState,
                            ); // Pass setState
                          },
                        ),
                      ),
                      onTap: () {
                        _selectTime(
                          context,
                          checkOutController,
                          setStateDialog,
                          setState,
                        ); // Pass setState
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed:
                      _isFormValid() ? () => _saveAttendance(context) : null,
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AttendanceBloc, AttendanceState>(
      listener: (context, state) {
        if (state is AttendanceUpdated) {
          // Re-fetch data for the current date after update
          final currentDate = dateController.text;
          if (currentDate.isNotEmpty) {
            BlocProvider.of<AttendanceBloc>(
              context,
            ).add(FetchAttendanceEvent(currentDate));
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Attendance Manager')),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
              ListTile(
                title: const Text('Employees'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmployeeManagementScreen(),
                    ),
                  );
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
                    BlocProvider.of<AttendanceBloc>(
                      context,
                    ).add(FetchAttendanceEvent(dateController.text));
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
                          String overtime = calculateOvertime(
                            attendance.checkIn,
                            attendance.checkOut,
                          );
                          return Card(
                            child: ListTile(
                              title: Text(attendance.employeeName),
                              subtitle: Text(
                                'Check-In: ${attendance.checkIn}, Check-Out: ${attendance.checkOut}, Overtime: $overtime',
                              ),
                              trailing: Text(attendance.status),
                            ),
                          );
                        },
                      );
                    }
                    if (state is AttendanceError) {
                      return Center(child: Text(state.message));
                    }
                    return const Center(
                      child: Text('Select a date to fetch attendance'),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ReusableButton(
                label: 'Update Attendance',
                onPressed: () {
                  _updateAttendance(context);
                },
              ),
            ],
          ),
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

  @override
  void dispose() {
    dateController.dispose();
    checkInController.dispose();
    checkOutController.dispose();
    super.dispose();
  }
}
