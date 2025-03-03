import 'package:googleapis/sheets/v4.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_constants.dart';
import '../../domain/entities/attendance.dart';
import '../models/attendance_model.dart';

// This class handles remote data fetching for attendance using Google Sheets API.
class AttendanceRemoteDataSource {
  final SheetsApi sheetsApi;

  AttendanceRemoteDataSource({required this.sheetsApi});

  Future<List<AttendanceModel>> fetchAttendance(String date) async {
    try {
      final spreadsheetId = AppConstants.spreadsheetId;
      final range = '${AppConstants.attendanceSheetName}!A1:D';

      final response = await sheetsApi.spreadsheets.values.get(spreadsheetId, range);

      if (response.values != null) {
        List<AttendanceModel> attendanceList = [];
        List<List<dynamic>> rows = response.values!;

        for (int i = 1; i < rows.length; i++) {
          var row = rows[i];
          if (row[0] == date) {
            attendanceList.add(AttendanceModel(
              date: row[0] ?? '',
              employeeName: row[1] ?? '',
              checkIn: row[2] ?? '',
              checkOut: row[3] ?? '',
              status: row[4] ?? '',
            ));
          }
        }

        if (attendanceList.isEmpty) {
          throw ServerFailure('No Attendance Data Found for Selected Date');
        }

        return attendanceList;
      } else {
        throw ServerFailure('No attendance data found');
      }
    } catch (e) {
      print("Error in fetchAttendance: $e");
      throw ServerFailure('Failed to fetch attendance: ${e.toString()}');
    }
  }

  Future<void> updateAttendance(Attendance attendance) async {
    try {
      final spreadsheetId = AppConstants.spreadsheetId;
      final range = '${AppConstants.attendanceSheetName}!A2:D2';

      final valueRange = ValueRange(
        range: range,
        values: [
          [attendance.employeeName, attendance.date, attendance.checkIn, attendance.checkOut]
        ],
      );

      await sheetsApi.spreadsheets.values.update(
        valueRange,
        spreadsheetId,
        range,
        valueInputOption: 'RAW',
      );

      print("Attendance updated successfully.");
    } catch (e) {
      print("Error in updateAttendance: $e");
    }
  }

  Future<void> addAttendance(AttendanceModel attendance) async {
    try {
      final spreadsheetId = AppConstants.spreadsheetId;
      final range = '${AppConstants.attendanceSheetName}!A1:E'; // Adjust range to match your sheet

      final valueRange = ValueRange(
        values: [
          [
            attendance.date,
            attendance.employeeName,
            attendance.checkIn,
            attendance.checkOut,
            attendance.status,
          ]
        ],
      );

      await sheetsApi.spreadsheets.values.append(
        valueRange,
        spreadsheetId,
        range,
        valueInputOption: 'USER_ENTERED',
      );

      print("Attendance added successfully.");
    } catch (e) {
      print("Error in addAttendance: $e");
      throw ServerFailure('Failed to add attendance: ${e.toString()}');
    }
  }
}

