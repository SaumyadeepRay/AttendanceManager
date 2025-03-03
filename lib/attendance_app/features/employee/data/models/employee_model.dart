import '../../domain/entities/employee.dart';

// EmployeeModel is a data model that extends the Employee entity.
// It represents the data structure used for API communication and JSON serialization.
class EmployeeModel extends Employee {
  const EmployeeModel({
    required String employeeName,
    required bool isActive,
  }) : super(
    employeeName: employeeName,
    isActive: isActive,
  );

  // Factory method to create an EmployeeModel object from JSON data.
  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      employeeName: json['name'] ?? '', // Employee name from JSON data
      isActive: json['isActive'].toString().toLowerCase() == 'true', // Converting string to boolean
    );
  }

  // Converts the EmployeeModel object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': employeeName, // Employee name to JSON
      'isActive': isActive.toString(), // Converting boolean to string
    };
  }
}
