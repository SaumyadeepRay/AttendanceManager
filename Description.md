# Attendance Manager Flutter Project - Detailed Explanation

## Overview
The Attendance Manager is a Flutter-based application designed to manage employee attendance records efficiently. It integrates with **Google Sheets API** to store and retrieve attendance data, ensuring seamless record-keeping. The app follows the **Clean Architecture** approach, maintaining a well-structured, modular, and scalable codebase.

---

## 1. Clean Architecture Overview
The project is structured based on **Clean Architecture**, which separates concerns into three main layers:

### **A. Data Layer** (Handles data operations)
- **Remote Data Source:** Fetches and updates attendance records via Google Sheets API.
- **Models & Entities:** `AttendanceModel` extends `Attendance` for JSON conversion.
- **Repository Implementation:** Implements `AttendanceRepository` to interact with the data sources.

### **B. Domain Layer** (Contains business logic)
- **Entities:** Defines core business objects (`Attendance`).
- **Use Cases:** Encapsulates the application's business rules (e.g., `GetAttendance`, `UpdateAttendance`).
- **Repositories:** Defines an abstract repository interface (`AttendanceRepository`), implemented in the Data layer.
- **Dartz Functional Error Handling:** Uses `Either<Failure, Success>` for predictable error management.

### **C. Presentation Layer** (UI & State Management)
- **State Management:** `AttendanceBloc` (using `flutter_bloc` package) manages UI states.
- **UI Components:** `HomeScreen`, `AttendanceListItem`, `AttendanceDialog`.
- **Events & States:** `AttendanceEvent` (triggers actions), `AttendanceState` (represents UI state).

---

## 2. Features & Implementation

### **A. Fetch Attendance Records**
- The user selects a date.
- The app fetches attendance data from Google Sheets.
- Uses `Bloc` to manage API calls and UI updates.
- **Code Reference:**
  ```dart
  class FetchAttendanceEvent extends AttendanceEvent {
    final String date;
    FetchAttendanceEvent(this.date);
  }
  ```

### **B. Add/Update Attendance**
- The user enters details (`name`, `date`, `check-in`, `check-out`).
- If an entry with the same `name` and `date` exists, it updates the record instead of creating a new one.
- **Code Reference:**
  ```dart
  void _saveAttendance(BuildContext context) {
    final newAttendance = Attendance(
      date: datePopupController.text,
      employeeName: employeeNameController.text,
      checkIn: checkInController.text,
      checkOut: checkOutController.text,
      status: 'Present',
    );
    BlocProvider.of<AttendanceBloc>(context).add(UpdateAttendanceEvent(newAttendance));
  }
  ```

### **C. Overtime Calculation**
- Automatically calculates overtime if the total working hours exceed **9 hours**.
- **Code Reference:**
  ```dart
  String calculateOvertime(String checkIn, String checkOut) {
    DateTime inTime = DateTime.parse('2025-03-01T$checkIn');
    DateTime outTime = DateTime.parse('2025-03-01T$checkOut');
    Duration difference = outTime.difference(inTime);
    return difference.inMinutes > 540 ? '${difference.inHours}h ${difference.inMinutes % 60}m' : '0h 0m';
  }
  ```

### **D. Google Sheets API Integration**
- Uses **Google Sheets as a backend database**.
- Fetch, insert, and update attendance records via Google Sheets API.
- **Code Reference:**
  ```dart
  Future<List<Attendance>> fetchAttendance(String date) async {
    final response = await http.get(Uri.parse('https://sheets.googleapis.com/v4/spreadsheets/...'));
    return parseAttendanceData(response.body);
  }
  ```

---

## 3. Technologies & Packages Used
- **Flutter:** Frontend framework
- **Bloc:** State management
- **Google Sheets API:** Backend database
- **Dartz:** Functional programming utilities
- **Intl:** Date formatting

---


This document provides a comprehensive overview of the **Attendance Manager** project. Let me know if you need any modifications! 🚀

