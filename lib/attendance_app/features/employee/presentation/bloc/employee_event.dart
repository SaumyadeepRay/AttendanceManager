import 'package:equatable/equatable.dart';

import '../../domain/entities/employee.dart';

// Abstract base class for all employee-related events.
// Events represent actions that can trigger state changes in the BLoC.

abstract class EmployeeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Event to fetch all employee records.
// This event is dispatched when the user requests the employee list.
class FetchEmployeesEvent extends EmployeeEvent {}

// Event to add a new employee.
// It accepts an Employee entity containing the employee data to be added.
class AddEmployeeEvent extends EmployeeEvent {
  final Employee employee;

  AddEmployeeEvent(this.employee);

  @override
  List<Object> get props => [employee]; // Props used for value comparison in tests
}

// Event to remove an employee by their name.
// It accepts the employee name as input.
class RemoveEmployeeEvent extends EmployeeEvent {
  final String employeeName;

  RemoveEmployeeEvent(this.employeeName);

  @override
  List<Object> get props => [employeeName]; // Props used for value comparison in tests
}
