// Implementation of repository

import '../../../../core/errors/failures.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/employee_remote_datasource.dart';
import '../models/employee_model.dart';

// EmployeeRepositoryImpl implements the EmployeeRepository interface.
// It serves as a bridge between the data layer and domain layer.
class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource remoteDataSource; // Remote data source for API calls

  EmployeeRepositoryImpl({required this.remoteDataSource});

  // Fetch the list of employees from the remote data source.
  @override
  Future<List<Employee>> fetchEmployees() async {
    try {
      // Fetch employees from the remote data source.
      final employeeList = await remoteDataSource.fetchEmployees();
      return employeeList; // Return the list of employees.
    } catch (e) {
      throw ServerFailure('Failed to fetch employees: ${e.toString()}');
    }
  }

  // Add a new employee using the remote data source.
  @override
  Future<void> addEmployee(Employee employee) async {
    try {
      // Convert Employee entity to EmployeeModel for JSON serialization.
      final employeeModel = EmployeeModel(
        employeeName: employee.employeeName,
        isActive: employee.isActive,
      );

      // Add employee through the remote data source.
      await remoteDataSource.addEmployee(employeeModel);
    } catch (e) {
      throw ServerFailure('Failed to add employee: ${e.toString()}');
    }
  }

  // Remove an employee using the remote data source.
  @override
  Future<void> removeEmployee(String employeeName) async {
    try {
      // Call the remote data source to remove employee by name.
      await remoteDataSource.removeEmployee(employeeName);
    } catch (e) {
      throw ServerFailure('Failed to remove employee: ${e.toString()}');
    }
  }
}