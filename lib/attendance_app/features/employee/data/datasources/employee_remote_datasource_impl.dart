import 'package:googleapis/sheets/v4.dart';

import '../../../../core/utils/app_constants.dart';
import '../models/employee_model.dart';
import 'employee_remote_datasource.dart';

class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final SheetsApi sheetsApi;
  final String _spreadsheetId = AppConstants.spreadsheetId;

  EmployeeRemoteDataSourceImpl({required this.sheetsApi});

  @override
  Future<void> addEmployee(EmployeeModel employee) async {
    await sheetsApi.spreadsheets.values.append(
      ValueRange(values: [
        [employee.employeeName, employee.isActive.toString()]
      ]),
      _spreadsheetId,
      'Employees!A2:B',
      valueInputOption: 'RAW',
    );
  }

  @override
  Future<List<EmployeeModel>> fetchEmployees() {
    // TODO: implement fetchEmployees
    throw UnimplementedError();
  }

  @override
  Future<void> removeEmployee(String employeeName) {
    // TODO: implement removeEmployee
    throw UnimplementedError();
  }
}