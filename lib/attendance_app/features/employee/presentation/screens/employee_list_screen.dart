import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/reusable_button.dart';
import '../../../../core/widgets/reusable_loader.dart';
import '../bloc/employee_bloc.dart';
import '../../domain/entities/employee.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';

// EmployeeListScreen displays the list of employee records.
// It provides functionality to fetch, add, and remove employees.
class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({Key? key}) : super(key: key);

  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final TextEditingController employeeNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<EmployeeBloc>(context).add(FetchEmployeesEvent()); // Fetch Employees when screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: employeeNameController,
              decoration: const InputDecoration(
                hintText: 'Enter Employee Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            BlocConsumer<EmployeeBloc, EmployeeState>(
              listener: (context, state) {
                if (state is EmployeeAdded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Employee Added Successfully!')),
                  );
                  employeeNameController.clear();
                  BlocProvider.of<EmployeeBloc>(context).add(FetchEmployeesEvent());
                } else if (state is EmployeeError) {
                  print("Server Error: ${state.message}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return ReusableButton(
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
                );
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<EmployeeBloc, EmployeeState>(
                builder: (context, state) {
                  if (state is EmployeeLoading) {
                    return const ReusableLoader();
                  }
                  if (state is EmployeeLoaded) {
                    return ListView.builder(
                      itemCount: state.employees.length,
                      itemBuilder: (context, index) {
                        final employee = state.employees[index];
                        return Card(
                          child: ListTile(
                            title: Text(employee.employeeName),
                            trailing: employee.isActive
                                ? IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                BlocProvider.of<EmployeeBloc>(context)
                                    .add(RemoveEmployeeEvent(employee.employeeName));
                              },
                            )
                                : const Text('Inactive', style: TextStyle(color: Colors.grey)),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: Text('No employees available'));
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