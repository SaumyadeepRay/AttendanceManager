import '../../domain/entities/attendance.dart';

// Abstract base class for all attendance-related states.
// States represent the UI conditions managed by the BLoC.

abstract class AttendanceState {}

// Initial state when the BLoC is first created.
// This state indicates no action has been performed yet.
class AttendanceInitial extends AttendanceState {}

// State when attendance data is being loaded.
// It is emitted before fetching or updating data.
class AttendanceLoading extends AttendanceState {}

// State when attendance data is successfully fetched.
// It holds the list of attendance records to display on the UI.
class AttendanceLoaded extends AttendanceState {
  final List<Attendance> attendances; // List of fetched attendance records

  AttendanceLoaded({required this.attendances});

  @override
  List<Object> get props => [attendances]; // Props used for value comparison in tests
}

// State when attendance data is successfully updated.
// It notifies the UI about the successful operation.
class AttendanceUpdated extends AttendanceState {}

// State when an error occurs during attendance operations.
// It holds an error message to display on the UI.
class AttendanceError extends AttendanceState {
  final String message; // Error message

  AttendanceError({required this.message});

  @override
  List<Object> get props => [message]; // Props used for value comparison in tests
}
