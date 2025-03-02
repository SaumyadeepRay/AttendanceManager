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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<EmployeeBloc>(context).add(FetchEmployeesEvent());
    });
  }

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
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter an employee name')),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocConsumer<EmployeeBloc, EmployeeState>(
                listener: (context, state) {
                  if (state is EmployeeAdded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Employee Added Successfully!')),
                    );
                    employeeNameController.clear();
                    BlocProvider.of<EmployeeBloc>(context).add(FetchEmployeesEvent());
                  } else if (state is EmployeeRemoved) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Employee Removed Successfully!')),
                    );
                    BlocProvider.of<EmployeeBloc>(context).add(FetchEmployeesEvent());
                  } else if (state is EmployeeError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is EmployeeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is EmployeeLoaded) {
                    if (state.employees.isEmpty) {
                      return const Center(child: Text('No Employees Found'));
                    }
                    return ListView.builder(
                      itemCount: state.employees.length,
                      itemBuilder: (context, index) {
                        final employee = state.employees[index];
                        return ListTile(
                          title: Text(employee.employeeName),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              BlocProvider.of<EmployeeBloc>(context).add(RemoveEmployeeEvent(employee.employeeName));
                            },
                          ),
                        );
                      },
                    );
                  } else if (state is EmployeeError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('No Employees Found'));
                },
              ),
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
