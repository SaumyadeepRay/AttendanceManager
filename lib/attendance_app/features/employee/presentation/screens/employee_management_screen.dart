import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/reusable_button.dart';
import '../../../../core/widgets/reusable_text_field.dart';
import '../bloc/employee_bloc.dart';
import '../../domain/entities/employee.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';
import '../widgets/employee_card.dart';

class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({Key? key}) : super(key: key);

  @override
  _EmployeeManagementScreenState createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  final TextEditingController employeeNameController = TextEditingController();
  String? removingEmployeeName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeBloc>().add(FetchEmployeesEvent());
    });
  }

  void _addEmployee() {
    final String employeeName = employeeNameController.text.trim();
    if (employeeName.isEmpty) {
      _showSnackbar('Please enter an employee name');
      return;
    }

    final employeeBloc = context.read<EmployeeBloc>();
    final currentState = employeeBloc.state;

    if (currentState is EmployeeLoaded &&
        currentState.employees.any(
              (e) => e.employeeName.toLowerCase() == employeeName.toLowerCase(),
        )) {
      _showSnackbar('Employee already exists!');
      return;
    }

    employeeBloc.add(
      AddEmployeeEvent(Employee(employeeName: employeeName, isActive: true)),
    );

    // Ensure UI updates properly after adding
    setState(() {
      removingEmployeeName = null; // Reset remove state
    });
  }

  void _removeEmployee(String employeeName) {
    setState(() => removingEmployeeName = employeeName);
    context.read<EmployeeBloc>().add(RemoveEmployeeEvent(employeeName));

    // Ensure UI updates properly after removing
    setState(() {
      removingEmployeeName = null;
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ReusableTextField(
              hintText: 'Employee Name',
              controller: employeeNameController,
            ),
            const SizedBox(height: 10),
            ReusableButton(label: 'Add Employee', onPressed: _addEmployee),
            const SizedBox(height: 20),
            Expanded(
              child: BlocConsumer<EmployeeBloc, EmployeeState>(
                listener: (context, state) {
                  if (state is EmployeeSuccess) {
                    _showSnackbar(state.message);
                    employeeNameController.clear();
                    context.read<EmployeeBloc>().add(FetchEmployeesEvent());
                  } else if (state is EmployeeError) {
                    _showSnackbar(state.message);
                    setState(() => removingEmployeeName = null);
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
                        return EmployeeCard(
                          employee: employee,
                          onRemove: removingEmployeeName == employee.employeeName
                              ? null
                              : () => _removeEmployee(employee.employeeName),
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
