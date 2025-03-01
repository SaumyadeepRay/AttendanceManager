import 'package:flutter/material.dart';
import '../../domain/entities/employee.dart';

// EmployeeListItem is a reusable widget to display an individual employee in a list.
// It shows the employee name and active status along with an optional delete button.
class EmployeeListItem extends StatelessWidget {
  final Employee employee; // Employee entity to display
  final VoidCallback? onRemove; // Optional callback for removal action

  const EmployeeListItem({
    required this.employee,
    this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0, // Shadow effect for better UI
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        title: Text(
          employee.employeeName, // Display employee name
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          employee.isActive ? 'Active' : 'Inactive', // Display employee status
          style: TextStyle(color: employee.isActive ? Colors.green : Colors.red),
        ),
        trailing: onRemove != null
            ? IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onRemove, // Trigger removal callback
        )
            : null, // Only show delete button if callback is provided
      ),
    );
  }
}
