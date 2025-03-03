import 'package:googleapis/sheets/v4.dart';

// ApiClient class is responsible for making network requests using the HTTP package.
// This class is reusable across the entire app for all network-related requests.
class ApiClient {
  final SheetsApi sheetsApi;

  ApiClient({required this.sheetsApi});

  Future<List<List<Object?>>?> fetchSpreadsheetData(String spreadsheetId, String range) async {
    try {
      var response = await sheetsApi.spreadsheets.values.get(spreadsheetId, range);
      return response.values;
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<void> updateSpreadsheetData(String spreadsheetId, String range, List<List<Object>> values) async {
    try {
      var valueRange = ValueRange(values: values);
      await sheetsApi.spreadsheets.values.update(
        valueRange,
        spreadsheetId,
        range,
        valueInputOption: 'RAW',
      );
    } catch (e) {
      throw Exception('Failed to update data: $e');
    }
  }
}

