import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

// Use case class to fetch attendance records for a specific date.
// This class acts as an application business logic layer that interacts with the repository.
class GetAttendance {
  final AttendanceRepository repository; // Repository instance to perform data fetching.

  GetAttendance(this.repository);

  // This method executes the use case by calling the repository.
  // It accepts the date as a parameter and returns either a list of attendance records or a failure.
  Future<Either<Failure, List<Attendance>>> execute(String date) async {
    try {
      // Fetching attendance records from the repository
      final attendanceList = await repository.fetchAttendance(date);
      if (attendanceList.isEmpty) {
        return Left(ServerFailure('No attendance records found for this date.'));
      }
      return Right(attendanceList);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch attendance: ${e.toString()}'));
    }
  }
}