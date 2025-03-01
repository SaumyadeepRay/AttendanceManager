import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/attendance/domain/entities/attendance.dart';
import '../errors/failures.dart';

// ApiClient class is responsible for making network requests using the HTTP package.
// This class is reusable across the entire app for all network-related requests.
class ApiClient {
  final http.Client client; // HTTP client for making network requests.

  // Constructor that takes an HTTP client as a dependency for better testability.
  ApiClient({required this.client});

  // GET request method to fetch data from the provided URL.
  // It returns an HTTP response if the request is successful.
  Future<http.Response> get(String url) async {
    try {
      final response = await client.get(Uri.parse(url)); // Making a GET request to the URL.

      if (response.statusCode == 200) {
        // If the request is successful, return the HTTP response.
        return response;
      } else {
        // If the request fails, throw a ServerFailure with the status code message.
        throw ServerFailure('Failed to load data with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Catching any network-related exception and throwing a ServerFailure with the exception message.
      throw ServerFailure('Network error: ${e.toString()}');
    }
  }

  // POST request method to send data to the provided URL.
  // It takes the URL and request body as parameters.
  Future<http.Response> post(String url, dynamic body) async {
    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body), // Convert body to JSON string
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // If the request is successful, return the HTTP response.
        return response;
      } else {
        // If the request fails, throw a ServerFailure with the status code message.
        throw ServerFailure('Failed to post data with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Catching any network-related exception and throwing a ServerFailure with the exception message.
      throw ServerFailure('Network error: ${e.toString()}');
    }
  }

  // PUT request method to send data to the provided URL for updates.
  Future<http.Response> put(String url, dynamic body) async {
    try {
      final response = await client.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body), // Convert body to JSON string
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // If the request is successful, return the HTTP response.
        return response;
      } else {
        // If the request fails, throw a ServerFailure with the status code message.
        throw ServerFailure('Failed to update data with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Catching any network-related exception and throwing a ServerFailure with the exception message.
      throw ServerFailure('Network error: ${e.toString()}');
    }
  }
}
