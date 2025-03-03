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
    on<FetchAttendanceEvent>(_onFetchAttendance);
    on<UpdateAttendanceEvent>(_onUpdateAttendance);
  }

  Future<void> _onFetchAttendance(
      FetchAttendanceEvent event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    final result = await getAttendance.execute(event.date);

    result.fold(
          (failure) => emit(AttendanceError(message: _mapFailureToMessage(failure))),
          (attendanceList) => emit(AttendanceLoaded(attendances: attendanceList)),
    );
  }

  Future<void> _onUpdateAttendance(
      UpdateAttendanceEvent event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    final result = await updateAttendance.execute(event.attendance);

    result.fold(
          (failure) => emit(AttendanceError(message: _mapFailureToMessage(failure))),
          (_) => emit(AttendanceUpdated()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Failed to fetch data. Please try again!';
      case CacheFailure:
        return 'Cache Error! Please refresh the page.';
      case ValidationFailure:
        return 'Invalid input! Please check your data.';
      default:
        return 'Unexpected Error Occurred!';
    }
  }
}
