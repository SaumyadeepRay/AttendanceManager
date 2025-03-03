import 'package:equatable/equatable.dart';
import '../../domain/entities/employee.dart';

// Abstract base class for all employee-related events.
abstract class EmployeeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Event to fetch all employees
class FetchEmployeesEvent extends EmployeeEvent {}

// Event to add a new employee.
class AddEmployeeEvent extends EmployeeEvent {
  final Employee employee;

  AddEmployeeEvent(this.employee);

  @override
  List<Object> get props => [employee];
}

// Event to remove an employee.
class RemoveEmployeeEvent extends EmployeeEvent {
  final String employeeName;

  RemoveEmployeeEvent(this.employeeName);

  @override
  List<Object> get props => [employeeName];
}
