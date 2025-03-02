import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

// Use case class to update attendance records.
// This class contains the business logic for updating attendance data.
class UpdateAttendance {
  final AttendanceRepository repository; // Repository instance to interact with data layer.

  UpdateAttendance(this.repository);

  // Method to execute the update operation.
  // It accepts an Attendance entity as input and returns either success or failure.
  Future<Either<Failure, void>> execute(Attendance attendance) async {
    try {
      // Calling repository method to update attendance data.
      await repository.updateAttendance(attendance);
      return Right(null); // Returns success without any data on success
    } catch (e) {
      // Returns failure if an exception occurs.
      return Left(ServerFailure('Failed to update attendance: ${e.toString()}'));
    }
  }
}
