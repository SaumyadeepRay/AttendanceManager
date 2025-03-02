import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_employees.dart';
import '../../domain/usecases/add_employee.dart';
import '../../domain/usecases/remove_employee.dart';
import 'employee_event.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final GetEmployees getEmployees;
  final AddEmployee addEmployee;
  final RemoveEmployee removeEmployee;

  EmployeeBloc({
    required this.getEmployees,
    required this.addEmployee,
    required this.removeEmployee,
  }) : super(EmployeeInitial()) {
    on<FetchEmployeesEvent>((event, emit) async {
      emit(EmployeeLoading());
      final result = await getEmployees.execute();
      result.fold(
            (failure) => emit(EmployeeError(message: _mapFailureToMessage(failure))),
            (employeeList) => emit(EmployeeLoaded(employees: employeeList)),
      );
    });

    on<AddEmployeeEvent>((event, emit) async {
      emit(EmployeeLoading());
      final result = await addEmployee.execute(event.employee);
      result.fold(
            (failure) => emit(EmployeeError(message: _mapFailureToMessage(failure))),
            (_) => add(FetchEmployeesEvent()),
      );
    });

    on<RemoveEmployeeEvent>((event, emit) async {
      emit(EmployeeLoading());
      final result = await removeEmployee.execute(event.employeeName);
      result.fold(
            (failure) => emit(EmployeeError(message: _mapFailureToMessage(failure))),
            (_) => add(FetchEmployeesEvent()),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Failed to connect to the server. Please try again!';
      case CacheFailure:
        return 'Cache Error! Please refresh the page.';
      case ValidationFailure:
        return 'Invalid input! Please check your data.';
      default:
        return 'Unexpected Error Occurred!';
    }
  }
}
