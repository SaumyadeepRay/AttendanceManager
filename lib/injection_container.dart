import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'attendance_app/core/network/api_client.dart';
import 'attendance_app/features/attendance/data/datasources/attendance_remote_datasource.dart';
import 'attendance_app/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'attendance_app/features/attendance/domain/repositories/attendance_repository.dart';
import 'attendance_app/features/attendance/domain/usecases/get_attendance.dart';
import 'attendance_app/features/attendance/domain/usecases/update_attendance.dart';
import 'attendance_app/features/attendance/presentation/bloc/attendance_bloc.dart';

import 'attendance_app/features/employee/data/datasources/employee_remote_datasource.dart';
import 'attendance_app/features/employee/data/repositories/employee_repository_impl.dart';
import 'attendance_app/features/employee/domain/repositories/employee_repository.dart';
import 'attendance_app/features/employee/domain/usecases/get_employees.dart';
import 'attendance_app/features/employee/domain/usecases/add_employee.dart';
import 'attendance_app/features/employee/domain/usecases/remove_employee.dart';
import 'attendance_app/features/employee/presentation/bloc/employee_bloc.dart';

final sl = GetIt.instance; // Service Locator instance

// This function initializes all dependencies used throughout the app.
void init() {
  // Register HTTP Client
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => ApiClient(client: sl()));

  // Attendance Feature
  sl.registerLazySingleton(() => AttendanceRemoteDataSource(apiClient: sl()));
  sl.registerLazySingleton<AttendanceRepository>(() => AttendanceRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => GetAttendance(sl()));
  sl.registerLazySingleton(() => UpdateAttendance(sl()));
  sl.registerFactory(() => AttendanceBloc(getAttendance: sl(), updateAttendance: sl()));

  // Employee Feature
  sl.registerLazySingleton(() => EmployeeRemoteDataSource(apiClient: sl()));
  sl.registerLazySingleton<EmployeeRepository>(() => EmployeeRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => GetEmployees(sl()));
  sl.registerLazySingleton(() => AddEmployee(sl()));
  sl.registerLazySingleton(() => RemoveEmployee(sl()));
  sl.registerFactory(() => EmployeeBloc(
    getEmployees: sl(),
    addEmployee: sl(),
    removeEmployee: sl(),
  ));
}
