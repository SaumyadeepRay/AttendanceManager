import 'package:flutter/material.dart';
import '../../domain/entities/employee.dart';

// EmployeeCard is a reusable widget that displays employee information.
// It shows the employee's name and status with an optional remove button.
class EmployeeCard extends StatelessWidget {
  final Employee employee; // Employee entity containing employee data
  final VoidCallback? onRemove; // Callback function to trigger removal

  const EmployeeCard({
    required this.employee,
    this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0, // Elevation for shadow effect
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), // Rounded corners
      child: ListTile(
        title: Text(
          employee.employeeName, // Employee name
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          employee.isActive ? 'Active' : 'Inactive', // Employee status
          style: TextStyle(color: employee.isActive ? Colors.green : Colors.red),
        ),
        trailing: onRemove != null
            ? IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onRemove, // Trigger remove action
        )
            : null, // Show remove button only if onRemove callback is provided
      ),
    );
  }
}
