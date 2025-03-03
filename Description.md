# Attendance Manager

## Project Overview
Attendance Manager is a Flutter-based application designed to help admins efficiently manage employee attendance records. The app integrates with Google Sheets API to store and update attendance data, calculate overtime, and manage employee lists.

## Features

### 1. Home Screen
- Displays a list of employees with corresponding **Check-in** and **Check-out** times.
- Automatically pre-fills default **Check-in** and **Check-out** times if no entry exists for the selected date.
- Fetches attendance records from Google Sheets if data already exists.
- Allows manual modification of **Check-in** and **Check-out** times.
- Automatically calculates **Overtime** hours if total working hours exceed **9 hours**.
- Updates the modified data into Google Sheets.

#### Home Screen Layout
```
---------------------------------------------------
| Date: [Selected Date]                              |
---------------------------------------------------
| Employee Name | Check-in | Check-out | Overtime |
|-------------------------------------------------|
| John Doe     | 09:00 AM | 06:00 PM  | 0h       |
| Jane Smith   | 08:30 AM | 07:30 PM  | 1h       |
|-------------------------------------------------|
| [Update Attendance]                              |
---------------------------------------------------
```

### 2. Update Attendance Records
- Fetch attendance records for any selected date.
- Modify **Check-in** and **Check-out** times.
- Save updated records to Google Sheets.

### 3. Employee Management Page
- Displays a list of employees.
- Admin can:
    - Add new employees.
    - Remove existing employees (Only deactivates future submissions, not the data in Google Sheets).
- Updates employee list in Google Sheets.

#### Employee Management Layout
```
---------------------------------------------------
| Employees List                                   |
---------------------------------------------------
| Employee Name | Action                           |
|-------------------------------------------------|
| John Doe     | [Remove]                         |
| Jane Smith   | [Remove]                         |
|-------------------------------------------------|
| [Add New Employee]                               |
---------------------------------------------------
```

### 4. Google Sheets Integration
- Store new attendance records.
- Retrieve existing records for modification.
- Update specific records based on **Date** and **Employee Name**.
- Maintain an updated employee list.

## Architecture
- State Management: **BLoC**
- Google Sheets API integration for data storage and retrieval.
- Modular code structure with clean and maintainable codebase.

## Evaluation Criteria
- Code Quality
- UI/UX Design
- Google Sheets Integration
- State Management with BLoC
- Validation for missing or incorrect entries

## How to Run
1. Clone the repository:
```bash
git clone https://github.com/SaumyadeepRay/AttendanceManager.git
```
2. Install dependencies:
```bash
flutter pub get
```
3. Run the app:
```bash
flutter run
```

## Submission Guidelines
1. Record a short video demonstrating the app's functionality.
2. Explain architectural choices and feature implementation.
3. Share the GitHub repository link.
4. Ensure the code is clean, modular, and well-commented.




