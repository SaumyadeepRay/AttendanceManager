import '../entities/attendance.dart';

// This abstract class defines the contract for attendance-related data operations.
// It acts as an interface that both the data layer and domain layer rely on.
abstract class AttendanceRepository {
  // Fetches attendance records for a specific date.
  // The method returns a list of Attendance entities asynchronously.
  Future<List<Attendance>> fetchAttendance(String date);

  // Updates attendance records by passing an Attendance entity.
  // This method ensures that the updated record is stored in the remote data source.
  Future<void> updateAttendance(Attendance attendance);
}