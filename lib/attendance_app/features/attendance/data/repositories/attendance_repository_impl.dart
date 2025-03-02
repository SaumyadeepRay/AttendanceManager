import '../../../../core/errors/failures.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_datasource.dart';
import '../models/attendance_model.dart';

// AttendanceRepositoryImpl is the implementation of the AttendanceRepository interface.
// It acts as a bridge between the data source and domain layer.
class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource; // Remote data source for API operations

  AttendanceRepositoryImpl({required this.remoteDataSource});

  // Fetch attendance records for the given date from the remote data source.
  @override
  Future<List<Attendance>> fetchAttendance(String date) async {
    try {
      // Calls the remote data source to fetch attendance data
      final attendanceList = await remoteDataSource.fetchAttendance(date);

      // Convert remote data models (e.g. AttendanceModel) to domain entities (e.g. Attendance)
      return attendanceList.map((model) => _mapToDomainEntity(model)).toList();
    } catch (e) {
      // Throws a ServerFailure if any exception occurs
      throw ServerFailure('Failed to fetch attendance: ${e.toString()}');
    }
  }

  // Update attendance record to the remote data source.
  @override
  Future<void> updateAttendance(Attendance attendance) async {
    try {
      final existingAttendances = await fetchAttendance(attendance.date);
      final exists = existingAttendances.any((a) =>
      a.employeeName == attendance.employeeName &&
          a.date == attendance.date
      );

      final model = _mapToModel(attendance);
      if (exists) {
        await remoteDataSource.updateAttendance(model); // Update existing row
      } else {
        await remoteDataSource.addAttendance(model); // Add new row
      }
    } catch (e) {
      throw ServerFailure('Failed to update attendance: ${e.toString()}');
    }
  }

  // Maps Attendance entity to AttendanceModel
  AttendanceModel _mapToModel(Attendance attendance) {
    return AttendanceModel(
      employeeName: attendance.employeeName,
      checkIn: attendance.checkIn,
      checkOut: attendance.checkOut,
      status: attendance.status,
      date: attendance.date,
    );
  }

  // Maps AttendanceModel to Attendance entity
  Attendance _mapToDomainEntity(AttendanceModel model) {
    return Attendance(
      employeeName: model.employeeName,
      checkIn: model.checkIn,
      checkOut: model.checkOut,
      status: model.status,
      date: model.date,
    );
  }

  @override
  // Placeholder for Google Sheets API functionality
  get googleSheetsApi => throw UnimplementedError();
}
