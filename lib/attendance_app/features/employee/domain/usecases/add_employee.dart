import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/employee.dart';
import '../repositories/employee_repository.dart';

// Use case class to add a new employee.
// This class contains the business logic to add employee data through the repository.
class AddEmployee {
  final EmployeeRepository repository; // Repository instance to interact with data layer.

  AddEmployee(this.repository);

  // Executes the use case by calling the repository's addEmployee method.
  // It accepts an Employee entity and returns either success or failure.
  Future<Either<Failure, void>> execute(Employee employee) async {
    try {
      // Calls the repository method to add the employee.
      await repository.addEmployee(employee);
      return const Right(null); // Returns success without any data
    } catch (e) {
      // Returns failure if any exception occurs.
      return Left(ServerFailure('Failed to add employee: ${e.toString()}'));
    }
  }
}