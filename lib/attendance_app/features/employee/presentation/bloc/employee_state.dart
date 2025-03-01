import '../../domain/entities/employee.dart';

// Abstract base class for all employee-related states.
// States represent the different UI conditions managed by the BLoC.

abstract class EmployeeState {}

// Initial state when the BLoC is first created.
// This state indicates no action has been performed yet.
class EmployeeInitial extends EmployeeState {}

// State when employee data is being loaded.
// It is emitted before fetching, adding, or removing employees.
class EmployeeLoading extends EmployeeState {}

// State when employee data is successfully fetched.
// It holds the list of employee records to display on the UI.
class EmployeeLoaded extends EmployeeState {
  final List<Employee> employees; // List of fetched employee records

  EmployeeLoaded({required this.employees});

  @override
  List<Object?> get props => [employees]; // Props used for value comparison in tests
}

// State when a new employee is successfully added.
// It notifies the UI about the successful operation.
class EmployeeAdded extends EmployeeState {}

// State when an employee is successfully removed.
// It notifies the UI about the successful removal operation.
class EmployeeRemoved extends EmployeeState {}

// State when an error occurs during employee operations.
// It holds an error message to display on the UI.
class EmployeeError extends EmployeeState {
  final String message; // Error message

  EmployeeError({required this.message});

  @override
  List<Object?> get props => [message]; // Props used for value comparison in tests
}
