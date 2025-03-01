import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/employee.dart';
import '../repositories/employee_repository.dart';

// Use case class to fetch the list of employees.
// This class acts as the business logic layer that retrieves employee data through the repository.
class GetEmployees {
  final EmployeeRepository repository; // Repository instance to interact with the data layer.

  GetEmployees(this.repository);

  // Executes the use case by calling the repository's fetchEmployees method.
  // It returns either a list of Employee entities or a Failure.
  Future<Either<Failure, List<Employee>>> execute() async {
    try {
      // Fetches employee data from the repository.
      final result = await repository.fetchEmployees();
      return Right(result); // Returns the list of employees on success
    } catch (e) {
      // Returns failure if any exception occurs.
      return Left(ServerFailure('Failed to fetch employees: ${e.toString()}'));
    }
  }
}
