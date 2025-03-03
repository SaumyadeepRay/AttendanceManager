// API calls for employees

import 'dart:convert';
import 'package:googleapis/sheets/v4.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/app_constants.dart';
import '../models/employee_model.dart';

// This class handles remote data fetching for employee records using Google Sheets API.
class EmployeeRemoteDataSource {
  final SheetsApi sheetsApi;

  EmployeeRemoteDataSource({required this.sheetsApi});

  // Fetch employee list from Google Sheets.
  Future<List<EmployeeModel>> fetchEmployees() async {
    try {
      final spreadsheetId = AppConstants.spreadsheetId;
      final range = '${AppConstants.employeeSheetName}!A1:B';

      final response = await sheetsApi.spreadsheets.values.get(spreadsheetId, range);

      if (response.values != null) {
        List<EmployeeModel> employeeList = [];
        List<List<dynamic>> rows = response.values!;

        // Skip the header row and iterate through the remaining rows
        for (int i = 1; i < rows.length; i++) {
          var row = rows[i];
          employeeList.add(EmployeeModel(
            employeeName: row[0] ?? '',
            isActive: row[1] ?? 'false' == 'true',
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
      final spreadsheetId = AppConstants.spreadsheetId;
      final range = '${AppConstants.employeeSheetName}!A1:B';

      final valueRange = ValueRange(
        range: range,
        values: [
          [employee.employeeName, employee.isActive.toString()]
        ],
      );

      await sheetsApi.spreadsheets.values.append(
        valueRange,
        spreadsheetId,
        '${AppConstants.employeeSheetName}!A1:B',
        valueInputOption: 'RAW',
      );

      print("Employee added successfully.");
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
