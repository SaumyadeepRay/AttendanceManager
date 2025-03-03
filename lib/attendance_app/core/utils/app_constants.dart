// This class holds all the constant values used across the app.
// Using a single constants file makes it easier to update and maintain common values.
class AppConstants {
  // Base URL for Google Sheets API
  static const String googleSheetApiBaseUrl = 'https://sheets.googleapis.com/v4/spreadsheets';

  // API Key to authenticate API requests
  static const String apiKey = 'AIzaSyCo2WW5kWF2FmmFT2J7m3f1tpTTkj0Cbbc';

  // Spreadsheet ID of the Google Sheet to be used
  static const String spreadsheetId = '1F4I6WJYBgjfEj7CstISyAjw2la6i1s1GJFVvTJb0SwQ';

  // Sheet Name for Attendance Data
  static const String attendanceSheetName = 'Attendance';

  // Sheet Name for Employee Data
  static const String employeeSheetName = 'Employees';

  // Default Check-In Time for Employees
  static const String defaultCheckInTime = '09:00 AM';

  // Default Check-Out Time for Employees
  static const String defaultCheckOutTime = '06:00 PM';

  // Time format used throughout the app
  static const String timeFormat = 'hh:mm a';

  // Date format used throughout the app
  static const String dateFormat = 'yyyy-MM-dd';
}
