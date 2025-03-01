// API calls for employees

import 'dart:convert';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/app_constants.dart';
import '../models/employee_model.dart';

// This class handles remote data fetching for employee records using Google Sheets API.
class EmployeeRemoteDataSource {
  final ApiClient apiClient; // API client to make network requests

  EmployeeRemoteDataSource({required this.apiClient});

  // Fetch employee list from Google Sheets.
  Future<List<EmployeeModel>> fetchEmployees() async {
    try {
      // Construct API URL to fetch employee data.
      final url = '${AppConstants.googleSheetApiBaseUrl}/${AppConstants.spreadsheetId}/values/${AppConstants.employeeSheetName}?key=${AppConstants.apiKey}';

      // Perform GET request using ApiClient
      final response = await apiClient.get(url);
      final jsonData = json.decode(response.body);

      if (jsonData['values'] != null) {
        List<EmployeeModel> employeeList = [];
        List<dynamic> rows = jsonData['values'];

        // Skip the header row and iterate through the remaining rows
        for (int i = 1; i < rows.length; i++) {
          var row = rows[i];
          employeeList.add(EmployeeModel(
            employeeName: row[0]?.toString() ?? '',
            isActive: row[1]?.toString().toLowerCase() == 'true',
          ));
        }

        return employeeList.where((employee) => employee.employeeName.isNotEmpty).toList(); // Filtering valid entries
      } else {
        throw ServerFailure('No employee data found');
      }
    } catch (e) {
      throw ServerFailure('Failed to fetch employees: ${e.toString()}');
    }
  }

  // Add a new employee record to Google Sheets.
  Future<void> addEmployee(EmployeeModel employee) async {
    try {
      final url = '${AppConstants.googleSheetApiBaseUrl}/${AppConstants.spreadsheetId}/values/${AppConstants.employeeSheetName}:append?valueInputOption=RAW&key=${AppConstants.apiKey}';

      final Map<String, dynamic> body = {
        'values': [[employee.employeeName, employee.isActive.toString()]]
      };

      await apiClient.post(url, json.encode(body)); // Proper JSON Encoding
    } catch (e) {
      throw ServerFailure('Failed to add employee: ${e.toString()}');
    }
  }

  // Remove an employee by deactivating their record.
  Future<void> removeEmployee(String employeeName) async {
    try {
      final employees = await fetchEmployees();
      final employee = employees.firstWhere((e) => e.employeeName == employeeName, orElse: () => EmployeeModel(employeeName: '', isActive: false));

      if (employee.employeeName.isNotEmpty && employee.isActive) {
        final updatedEmployee = EmployeeModel(employeeName: employee.employeeName, isActive: false);
        await addEmployee(updatedEmployee);
      } else {
        throw ServerFailure('Employee already inactive or not found');
      }
    } catch (e) {
      throw ServerFailure('Failed to remove employee: ${e.toString()}');
    }
  }
}
