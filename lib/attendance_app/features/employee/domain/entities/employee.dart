// This class represents the Employee entity.
// It holds the core business model for employee data without any external dependencies.
class Employee {
  final String employeeName; // Name of the employee
  final bool isActive; // Employee status (Active/Inactive)

  // Constructor to initialize the Employee entity with required data.
  const Employee({
    required this.employeeName,
    required this.isActive,
  });

  // Overriding equality operator to compare two Employee objects.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Employee &&
        other.employeeName == employeeName &&
        other.isActive == isActive;
  }

  // Generates hash code based on object properties.
  @override
  int get hashCode => employeeName.hashCode ^ isActive.hashCode;

  // Converts Employee object to string format for debugging purposes.
  @override
  String toString() {
    return 'Employee(employeeName: $employeeName, isActive: $isActive)';
  }
}