import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import '../../../../core/errors/failures.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/employee_remote_datasource.dart';
import '../models/employee_model.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final sheets.SheetsApi _sheetsApi;
  final String _spreadsheetId;
  final EmployeeRemoteDataSource remoteDataSource;

  EmployeeRepositoryImpl(this._sheetsApi, this._spreadsheetId, {required this.remoteDataSource});

  // Fetch the list of employees from the remote data source.
  @override
  Future<List<EmployeeModel>> fetchEmployees() async {
    final response = await _sheetsApi.spreadsheets.values.get(
      _spreadsheetId,
      'Employees!A1:B',
    );

    if (response.values == null || response.values!.isEmpty) {
      return [];
    }

    return response.values!.skip(1).map((row) {
      return EmployeeModel(
        employeeName: row[0].toString(), // Convert Object? to String
        isActive: row[1].toString().toLowerCase() == 'true', // Ensure it's a String
      );
    }).toList();
  }

  // Add a new employee using the remote data source.
  @override
  Future<void> addEmployee(Employee employee) async {
    try {
      final employeeModel = EmployeeModel(
        employeeName: employee.employeeName,
        isActive: employee.isActive,
      );

      await remoteDataSource.addEmployee(employeeModel);
    } catch (e) {
      throw ServerFailure('Failed to add employee: ${e.toString()}');
    }
  }

  // Remove an employee using the remote data source.
  @override
  Future<void> removeEmployee(String employeeName) async {
    final employees = await fetchEmployees();
    print("Employees List: $employees");

    final index = employees.indexWhere((e) => e.employeeName == employeeName);
    print("Index of employee to remove: $index");

    if (index == -1) {
      print("Employee not found in the list");
      throw ServerFailure('Employee not found');
    }

    // ✅ Ensure the correct row index (considering header)
    int rowIndex = index + 2;  // +2 to account for headers
    print("Row index to delete in Google Sheets: $rowIndex");

    try {
      // Get the sheet ID dynamically
      final spreadsheet = await _sheetsApi.spreadsheets.get(_spreadsheetId);
      final sheet = spreadsheet.sheets!.firstWhere(
            (s) => s.properties!.title == "Employees", // Change if using a different sheet
        orElse: () => throw ServerFailure("Sheet not found"),
      );

      final sheetId = sheet.properties!.sheetId!;
      print("Sheet ID found: $sheetId");

      // Send delete request to Google Sheets API
      final batchUpdateRequest = sheets.BatchUpdateSpreadsheetRequest(
        requests: [
          sheets.Request(
            deleteDimension: sheets.DeleteDimensionRequest(
              range: sheets.DimensionRange(
                sheetId: sheetId, // ✅ Dynamically obtained sheet ID
                dimension: "ROWS",
                startIndex: rowIndex - 1, // Convert to 0-based index
                endIndex: rowIndex,
              ),
            ),
          ),
        ],
      );

      await _sheetsApi.spreadsheets.batchUpdate(batchUpdateRequest, _spreadsheetId);
      print("✅ Employee removed successfully from Google Sheets!");

      // ✅ Wait to ensure Google Sheets updates
      await Future.delayed(Duration(seconds: 2));

      // Verify deletion by refetching data
      final updatedEmployees = await fetchEmployees();
      print("Updated Employees List: $updatedEmployees");
    } catch (e) {
      print("❌ Error removing employee: $e");
      throw ServerFailure('Failed to remove employee: ${e.toString()}');
    }
  }

}
