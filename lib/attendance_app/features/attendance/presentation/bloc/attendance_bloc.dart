import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_attendance.dart';
import '../../domain/usecases/update_attendance.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';
import '../../domain/entities/attendance.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetAttendance getAttendance;
  final UpdateAttendance updateAttendance;

  AttendanceBloc({
    required this.getAttendance,
    required this.updateAttendance,
  }) : super(AttendanceInitial()) {
    on<FetchAttendanceEvent>((event, emit) async {
      emit(AttendanceLoading());
      final result = await getAttendance.execute(event.date);

      result.fold(
            (failure) => emit(AttendanceError(message: _mapFailureToMessage(failure))),
            (attendanceList) => emit(AttendanceLoaded(attendances: attendanceList)),
      );
    });

    on<UpdateAttendanceEvent>((event, emit) async {
      emit(AttendanceLoading());
      final result = await updateAttendance.execute(event.attendance);

      result.fold(
            (failure) => emit(AttendanceError(message: _mapFailureToMessage(failure))),
            (_) => emit(AttendanceUpdated()), // Emit only a success signal
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      print('Server failure details: ${failure.toString()}');
      return 'Failed to fetch data. Please try again!';
    } else if (failure is CacheFailure) {
      return 'Cache Error! Please refresh the page.';
    } else if (failure is ValidationFailure) {
      return 'Invalid input! Please check your data.';
    }
    return 'Unexpected Error Occurred!';
  }
}