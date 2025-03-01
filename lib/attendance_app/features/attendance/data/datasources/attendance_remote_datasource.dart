import 'dart:convert';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../employee/data/models/employee_model.dart';
import '../models/attendance_model.dart';

// This class handles remote data fetching for attendance using Google Sheets API.
class AttendanceRemoteDataSource {
  final ApiClient apiClient; // API client for making network requests

  AttendanceRemoteDataSource({required this.apiClient});

  // Fetch attendance data from Google Sheets for a given date.
  Future<List<AttendanceModel>> fetchAttendance(String date) async {
    try {
      // Construct the API URL to fetch attendance data
      final url = '${AppConstants.googleSheetApiBaseUrl}/${AppConstants.spreadsheetId}/values/${AppConstants.attendanceSheetName}?key=${AppConstants.apiKey}';
      print("Fetching attendance data from: $url");

      // Perform GET request using ApiClient
      final response = await apiClient.get(url);

      // Check if the response was successful
      if (response.statusCode != 200) {
        throw ServerFailure('Failed to fetch data: ${response.statusCode}');
      }

      final jsonData = json.decode(response.body);

      if (jsonData['values'] != null) {
        List<AttendanceModel> attendanceList = [];
        List<dynamic> rows = jsonData['values'];

        // Skip the header row and iterate through the remaining rows
        for (int i = 1; i < rows.length; i++) {
          var row = rows[i];
          if (row[0] == date) { // Checking if the date matches the requested date
            attendanceList.add(AttendanceModel(
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

        return attendanceList; // Returning list of attendance records
      } else {
        throw ServerFailure('No attendance data found');
      }
    } catch (e) {
      print("Error in fetchAttendance: $e");
      throw ServerFailure('Failed to fetch attendance: ${e.toString()}');
    }
  }

  // Update attendance data to Google Sheets
  Future<void> updateAttendance(AttendanceModel attendance) async {
    try {
      final url = '${AppConstants.googleSheetApiBaseUrl}/${AppConstants.spreadsheetId}/values/${AppConstants.attendanceSheetName}:update?valueInputOption=RAW&key=${AppConstants.apiKey}';
      print("Updating attendance data at: $url");

      // Creating JSON payload
      final Map<String, dynamic> body = {
        'values': [[attendance.employeeName, attendance.checkIn, attendance.checkOut, attendance.status]]
      };

      // Performing PUT request (for updating)
      final response = await apiClient.put(url, json.encode(body));

      // Check if response is successful
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerFailure('Failed to update attendance: ${response.body}');
      }
    } catch (e) {
      print("Error in updateAttendance: $e");
      throw ServerFailure('Failed to update attendance: ${e.toString()}');
    }
  }

  // Add employee to Google Sheets
  Future<void> addEmployee(EmployeeModel employee) async {
    try {
      final url = '${AppConstants.googleSheetApiBaseUrl}/${AppConstants.spreadsheetId}/values/${AppConstants.employeeSheetName}:append?valueInputOption=RAW&key=${AppConstants.apiKey}';
      print("Adding employee to: $url");

      final Map<String, dynamic> body = {
        'values': [[employee.employeeName, employee.isActive.toString()]]
      };

      print("Request Body: ${json.encode(body)}");

      final response = await apiClient.post(url, json.encode(body));

      // Check if the response is successful
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerFailure('Failed to add employee: ${response.body}');
      }
    } catch (e) {
      print("Error in addEmployee: $e");
      throw ServerFailure('Failed to add employee: ${e.toString()}');
    }
  }
}
