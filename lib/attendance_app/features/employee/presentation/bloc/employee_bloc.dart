import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_employees.dart';
import '../../domain/usecases/add_employee.dart';
import '../../domain/usecases/remove_employee.dart';
import 'employee_event.dart';
import 'employee_state.dart';

// EmployeeBloc manages employee-related business logic and states.
class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final GetEmployees getEmployees; // Use case to fetch employee data
  final AddEmployee addEmployee; // Use case to add an employee
  final RemoveEmployee removeEmployee; // Use case to remove an employee

  EmployeeBloc({
    required this.getEmployees,
    required this.addEmployee,
    required this.removeEmployee,
  }) : super(EmployeeInitial()) {

    // Event handler to fetch employees when FetchEmployeesEvent is triggered.
    on<FetchEmployeesEvent>((event, emit) async {
      emit(EmployeeLoading()); // Emit loading state before fetching data
      final result = await getEmployees.execute();
      result.fold(
            (failure) => emit(EmployeeError(message: _mapFailureToMessage(failure))),
            (employeeList) => emit(EmployeeLoaded(employees: employeeList)),
      );
    });

    // Event handler to add a new employee when AddEmployeeEvent is triggered.
    on<AddEmployeeEvent>((event, emit) async {
      emit(EmployeeLoading()); // Emit loading state before adding employee
      final result = await addEmployee.execute(event.employee);
      result.fold(
            (failure) => emit(EmployeeError(message: _mapFailureToMessage(failure))),
            (_) => emit(EmployeeAdded()),
      );
    });

    // Event handler to remove an employee when RemoveEmployeeEvent is triggered.
    on<RemoveEmployeeEvent>((event, emit) async {
      emit(EmployeeLoading()); // Emit loading state before removing employee
      final result = await removeEmployee.execute(event.employeeName);
      result.fold(
            (failure) => emit(EmployeeError(message: _mapFailureToMessage(failure))),
            (_) => emit(EmployeeRemoved()),
      );
    });
  }

  // Maps Failure object to user-friendly error messages.
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Failed to add data. Please try again!';
    } else if (failure is CacheFailure) {
      return 'Cache Error! Please refresh the page.';
    } else if (failure is ValidationFailure) {
      return 'Invalid input! Please check your data.';
    }
    return 'Unexpected Error Occurred!';
  }
}
