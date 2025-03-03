import 'package:attendance_manager/attendance_app/core/utils/app_constants.dart';
import 'package:googleapis/sheets/v4.dart';

import '../../../../core/errors/failures.dart';
import '../../../employee/data/models/employee_model.dart';
import '../../domain/entities/attendance.dart';
import '../models/attendance_model.dart';
import 'attendance_remote_datasource.dart';

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final SheetsApi sheetsApi;
  final String _spreadsheetId = AppConstants.spreadsheetId;
  final String _range = 'Attendance!A2:E';

  AttendanceRemoteDataSourceImpl({required this.sheetsApi});

  @override
  Future<List<AttendanceModel>> fetchAttendance(String date) async {
    final response = await sheetsApi.spreadsheets.values.get(
      _spreadsheetId,
      _range,
    );

    if (response.values == null) return [];

    return response.values!
        .map(
          (row) => AttendanceModel(
            date: row[0],
            employeeName: row[1],
            checkIn: row[2],
            checkOut: row[3],
            status: row[4],
          ),
        )
        .where((attendance) => attendance.date == date)
        .toList(); // Filter
  }

  @override
  Future<void> updateAttendance(Attendance attendance) async {
    int rowIndex = await _findRowIndex(attendance.date);

    if (rowIndex == -1) {
      throw ServerFailure("No Attendance Found for Selected Date");
    }

    await sheetsApi.spreadsheets.values.update(
      ValueRange(
        values: [
          [
            attendance.date,
            attendance.employeeName,
            attendance.checkIn,
            attendance.checkOut,
            attendance.status,
          ],
        ],
      ),
      _spreadsheetId,
      'Attendance!A$rowIndex',
      valueInputOption: 'USER_ENTERED',
    );

    print("Attendance Updated Successfully 🚀");
  }

  Future<int> _findRowIndex(String date) async {
    final response = await sheetsApi.spreadsheets.values.get(
      _spreadsheetId,
      _range,
    );
    if (response.values != null) {
      List<List<dynamic>> rows = response.values!;
      for (int i = 0; i < rows.length; i++) {
        String sheetDate = rows[i][0].toString().trim();
        if (sheetDate == date.trim()) {
          return i + 2; // Range started from A2
        }
      }
    }
    return -1; // When Data is not present
  }

  @override
  Future<void> addAttendance(AttendanceModel attendance) async {
    try {
      final existingAttendances = await fetchAttendance(attendance.date);
      final exists = existingAttendances.any(
        (a) =>
            a.employeeName == attendance.employeeName &&
            a.date == attendance.date,
      );

      if (exists) {
        await updateAttendance(attendance); // Update existing
      } else {
        final valueRange =
            ValueRange()
              ..values = [
                [
                  attendance.date,
                  attendance.employeeName,
                  attendance.checkIn,
                  attendance.checkOut,
                  attendance.status,
                ],
              ];

        await sheetsApi.spreadsheets.values.append(
          valueRange,
          _spreadsheetId,
          _range,
          valueInputOption: 'USER_ENTERED',
        );

        print("Attendance Added Successfully 🚀");
      }
    } catch (e) {
      throw ServerFailure('Failed to update attendance: ${e.toString()}');
    }
  }
}
