import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/reusable_button.dart';
import '../../../../core/widgets/reusable_text_field.dart';
import '../bloc/employee_bloc.dart';
import '../../domain/entities/employee.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';

// EmployeeManagementScreen allows admins to add or remove employees.
// It provides input fields and action buttons to manage employee data.
class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({Key? key}) : super(key: key);

  @override
  _EmployeeManagementScreenState createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  final TextEditingController employeeNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ReusableTextField(
              hintText: 'Employee Name',
              controller: employeeNameController,
            ),
            const SizedBox(height: 10),
            ReusableButton(
              label: 'Add Employee',
              onPressed: () {
                if (employeeNameController.text.isNotEmpty) {
                  final employee = Employee(
                    employeeName: employeeNameController.text,
                    isActive: true,
                  );
                  BlocProvider.of<EmployeeBloc>(context).add(AddEmployeeEvent(employee));
                }
              },
            ),
            const SizedBox(height: 10),
            ReusableButton(
              label: 'Remove Employee',
              color: Colors.red,
              onPressed: () {
                if (employeeNameController.text.isNotEmpty) {
                  BlocProvider.of<EmployeeBloc>(context).add(RemoveEmployeeEvent(employeeNameController.text));
                }
              },
            ),
            const SizedBox(height: 20),
            BlocConsumer<EmployeeBloc, EmployeeState>(
              listener: (context, state) {
                if (state is EmployeeAdded || state is EmployeeRemoved) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state is EmployeeAdded ? 'Employee Added Successfully!' : 'Employee Removed Successfully!')),
                  );
                  employeeNameController.clear();
                } else if (state is EmployeeError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is EmployeeLoading) {
                  return const CircularProgressIndicator();
                }
                return const SizedBox.shrink();
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
    super.dispose();
  }
}
