import '../../data/datasources/employee_remote_datasource_impl.dart';
import '../../data/models/employee_model.dart';
import '../entities/employee.dart';

// This abstract class defines the contract for employee-related data operations.
// It acts as an interface that the data layer must implement.

abstract class EmployeeRepository {
  // Fetches the list of employees from the data source.
  // Returns a list of Employee entities.
  Future<List<Employee>> fetchEmployees();

  // Adds a new employee to the data source.
  // Accepts an Employee entity as input.
  Future<void> addEmployee(Employee employee);

  // Removes an employee from the data source by their name.
  // Accepts the employee name as input.
  Future<void> removeEmployee(String employeeName);
}