import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/employee_repository.dart';

// Use case class to remove an employee.
// This class contains the business logic for removing an employee by their name.
class RemoveEmployee {
  final EmployeeRepository repository; // Repository instance to interact with data layer.

  RemoveEmployee(this.repository);

  // Executes the use case by calling the repository's removeEmployee method.
  // It accepts an employee name and returns either success or failure.
  Future<Either<Failure, void>> execute(String employeeName) async {
    try {
      // Calls the repository method to remove the employee by name.
      await repository.removeEmployee(employeeName);
      return const Right(null); // Returns success without any data
    } catch (e) {
      // Returns failure if any exception occurs.
      return Left(ServerFailure('Failed to remove employee: ${e.toString()}'));
    }
  }
}