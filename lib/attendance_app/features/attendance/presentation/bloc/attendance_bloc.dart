import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_attendance.dart';
import '../../domain/usecases/update_attendance.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

// BLoC (Business Logic Component) class to handle the state and events of attendance feature.
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetAttendance getAttendance; // Use case to fetch attendance data.
  final UpdateAttendance updateAttendance; // Use case to update attendance data.

  AttendanceBloc({required this.getAttendance, required this.updateAttendance}) : super(AttendanceInitial()) {
    // Event handler to fetch attendance when FetchAttendanceEvent is triggered.
    on<FetchAttendanceEvent>((event, emit) async {
      emit(AttendanceLoading()); // Emit loading state before fetching data
      final result = await getAttendance.execute(event.date); // Execute use case

      result.fold(
            (failure) => emit(AttendanceError(message: _mapFailureToMessage(failure))), // Emit error state on failure
            (attendanceList) => emit(AttendanceLoaded(attendances: attendanceList)), // Emit loaded state on success
      );
    });

    // Event handler to update attendance when UpdateAttendanceEvent is triggered.
    on<UpdateAttendanceEvent>((event, emit) async {
      emit(AttendanceLoading()); // Emit loading state before updating data
      final result = await updateAttendance.execute(event.attendance); // Execute use case

      result.fold(
            (failure) => emit(AttendanceError(message: _mapFailureToMessage(failure))), // Emit error state on failure
            (_) => emit(AttendanceUpdated()), // Emit updated state on success
      );
    });
  }

  // Maps Failure object to user-friendly error messages.
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Failed to fetch data. Please try again!';
    } else if (failure is CacheFailure) {
      return 'Cache Error! Please refresh the page.';
    } else if (failure is ValidationFailure) {
      return 'Invalid input! Please check your data.';
    }
    return 'Unexpected Error Occurred!';
  }
}