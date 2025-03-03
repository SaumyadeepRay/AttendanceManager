import '../../domain/entities/attendance.dart';

// Abstract base class for all attendance-related events.
// Events represent actions that can trigger state changes in the BLoC.

abstract class AttendanceEvent {}

// Event to fetch attendance records for a given date.
// This event is dispatched when the user requests attendance data.
class FetchAttendanceEvent extends AttendanceEvent {
  final String date; // Date for which attendance needs to be fetched.

  FetchAttendanceEvent(this.date);

  @override
  List<Object> get props => [date]; // Props used for value comparison in tests
}

// Event to update an attendance record.
// This event is dispatched when the user wants to update attendance information.
class UpdateAttendanceEvent extends AttendanceEvent {
  final Attendance attendance; // Attendance entity containing updated information.

  UpdateAttendanceEvent(this.attendance);

  @override
  List<Object> get props => [attendance]; // Props used for value comparison in tests
}
