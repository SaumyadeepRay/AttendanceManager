import 'package:get_it/get_it.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:gsheets/gsheets.dart';
import 'package:http/http.dart' as http;

import '../../features/attendance/data/datasources/attendance_remote_datasource.dart';
import '../../features/attendance/data/datasources/attendance_remote_datasource_impl.dart';
import '../../features/attendance/data/repositories/attendance_repository_impl.dart';
import '../../features/attendance/domain/repositories/attendance_repository.dart';
import '../../features/attendance/domain/usecases/get_attendance.dart';
import '../../features/attendance/domain/usecases/update_attendance.dart';
import '../../features/attendance/presentation/bloc/attendance_bloc.dart';
import '../../features/employee/data/datasources/employee_remote_datasource.dart';
import '../../features/employee/data/datasources/employee_remote_datasource_impl.dart';
import '../../features/employee/data/repositories/employee_repository_impl.dart';
import '../../features/employee/domain/repositories/employee_repository.dart';
import '../../features/employee/domain/usecases/add_employee.dart';
import '../../features/employee/domain/usecases/get_employees.dart';
import '../../features/employee/domain/usecases/remove_employee.dart';
import '../../features/employee/presentation/bloc/employee_bloc.dart';
import '../utils/app_constants.dart';

class ServiceAccount {
  static const credentials = {
    // "type": "service_account",
    // "project_id": "attendance-manager-task",
    // "private_key_id": "30451ce0e16277c7be2135203a0c286f0be6e326",
    // "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDKzUAdLLs5709K\n7RXlYSlfUv/t40fMJ3UTWYLSf/DFZwvsHAkT72LBrkvJdw4BcyDYYd8SNpJplp2U\nud7uxeggv7RGJr4GrX6ChLREyTiGeFyPiRBaS51zmvE9QQLagGqHdXHzecLAUUFy\neqKnAloCPwgug9Dox/FpiHxVpBQ7KkV47KKYXQiy1uM88ZLrzeaxfxS0M5MKXFio\nzgifjzVKUDukL7jElqCt3fnuLW20IDNmLazYdT4M+VPm8skpQDIoBquQWonRicLa\nLjTaS299isE5Y5sQ3s1aYNXfPHI/qpUfZTNC6QPJbp4nhk0hrKpZ8RgFSNAn7sN1\nz3ZMyGT9AgMBAAECggEADcFrhe8SADwzPSW3NI+Nx3vMhOaxaMrnffBIjkIomfn5\n+q/IaP0+zhNKx2Vpq20TLOWKja2hfIytHSZPwxNSZpbTU/lcCY/FueNTHgZvI7hj\nQI+vXFZAy2XNihq5ZlMd7894l4vKXWSg9+AS3Yb1hT/pYzpNf7kcHHGX3fARyvCU\nUM4h6I4EaHoJs4hwjONu52CRlzqx3bUxaSUX80PcQ1ZLUrJU63q3jO2Wy+wWMh/e\nY6/BJxB56GrRAG9r+uhoc0MslhVmL5Y0vsmC/lHObbVHEvcETMJjp4jp1Cns8vVf\nvcy8XoUcBf653IN5ftRDXRAn8T5qA6HRG/ALDAt34wKBgQDxvMZVQPHXIL6HG3rD\n7SqciZ5kHmlUSLIHBv27SbXhX4LoQRf0iM7MagyNTmzQUFXO4LXL1QEw2HtGBCa5\n27dhM6THasocFiB4YZ5hyfIgtIOJXdpjqt8LFCxXo4hWSQ7ujRyqHIsoYD6zb19P\nAHGePSBimHmVG6FU8cdeBDw4swKBgQDWxGNSqXGMEMaXpVuSaWHEr3NHYCtrME8N\nbAMTFknm/7yhwVrMecSzfOLHZLvELlS8ReWlhnNsfm7s0aGnWbAyBm8OHGRJbS50\ntq/Ieh3B+hEKpuGSsyJVle4wCbipG0+vpwReQ3No4gvJkyfzXRF5ATZJ+NCjm7pS\nD1IelqrjjwKBgQC9QpzNNpGhamOBCASvzMll0WEO5bh1Yozvb4vLzEP39X1aNUx6\nCXpPFGBLabFLzvm/hLMQqO3LvlGVWb6wGNOT6IkEEBm4r6IwXc1QpnlJHcs2CyLm\nkWsbE2o8Gy6sz3o/Tn+4t6xDqkas2W93PNO3ngfy6YmXMhC3nqwGca5sfQKBgDIG\n+SPuOHbqCXiVmikWxyFrxSyhKDwFusRjnqu5i2l1tNjxE1eCHeG5e5H60wo1yKM6\nnO3bzdM9+FTN2BwFdleQzBm7X1kDR8kELRpD596hg4q5qN3lQGAzVpJ2ET/DDuLZ\nwti6WY3a6egAkVPNIB7Ru3Wrsd4KjnJDA1wAuLndAoGBALdKG0vfUHzojxMp6E+a\n41u5hITktYDB9i2VY1NZ6hsXIFOV0RA/rYLNzPsP9LwpXujrn1E/HqwKXMaD65Q7\nhrWgbBwdeIP1lcoD6EKZ1l7zw/suRRz3HwtXNW34OWVqbA/lhWAt98DvHycmJquZ\nzyRyj2684dhsjzNTRC2stsnc\n-----END PRIVATE KEY-----\n",
    // "client_email": "attendance-manager@attendance-manager-task.iam.gserviceaccount.com",
    // "client_id": "113886396371258873420",
    // "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    // "token_uri": "https://oauth2.googleapis.com/token",
    // "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    // "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/attendance-manager%40attendance-manager-task.iam.gserviceaccount.com",
    // "universe_domain": "googleapis.com"
  };
}

final sl = GetIt.instance; // Service Locator instance

// This function initializes all dependencies used throughout the app.
Future<void> init() async {
  // Register HTTP Client
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Authenticate and get SheetsApi instance
  final sheetsApi = await _authenticateServiceAccount();

  // Register SheetsApi instance
  sl.registerLazySingleton<SheetsApi>(() => SheetsApi(sheetsApi));

  // Attendance Feature
  sl.registerLazySingleton<AttendanceRemoteDataSource>(
        () => AttendanceRemoteDataSourceImpl(sheetsApi: sl()),
  );

  sl.registerLazySingleton<AttendanceRemoteDataSourceImpl>(
    () => AttendanceRemoteDataSourceImpl(sheetsApi: sl()),
  );

  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<GetAttendance>(
    () => GetAttendance(sl()),
  );
  sl.registerLazySingleton<UpdateAttendance>(
    () => UpdateAttendance(sl()),
  );
  sl.registerFactory<AttendanceBloc>(
    () => AttendanceBloc(
      getAttendance: sl(),
      updateAttendance: sl(),
    ),
  );

  // Employee Feature
  sl.registerLazySingleton<EmployeeRemoteDataSource>(
    () => EmployeeRemoteDataSourceImpl(sheetsApi: sl()),
  );
  sl.registerLazySingleton<EmployeeRepository>(
        () => EmployeeRepositoryImpl(
      sl<SheetsApi>(),               // Inject SheetsApi
      AppConstants.spreadsheetId,    // Inject spreadsheet ID
      remoteDataSource: sl<EmployeeRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<GetEmployees>(
    () => GetEmployees(sl()),
  );
  sl.registerLazySingleton<AddEmployee>(
    () => AddEmployee(sl()),
  );
  sl.registerLazySingleton<RemoveEmployee>(
    () => RemoveEmployee(sl()),
  );
  sl.registerFactory<EmployeeBloc>(
    () => EmployeeBloc(
      getEmployees: sl(),
      addEmployee: sl(),
      removeEmployee: sl(),
    ),
  );
}

Future<http.Client> _authenticateServiceAccount() async {
  final credentials = ServiceAccountCredentials.fromJson(ServiceAccount.credentials);
  final scopes = [SheetsApi.spreadsheetsScope];

  return await clientViaServiceAccount(credentials, scopes);
}

var sheetId = AppConstants.spreadsheetId;

final gSheetInit = GSheets(ServiceAccount.credentials);

var gSheetController;

Worksheet? gSheetCrudUserDetails;
Worksheet? gSheetEmployeesDetails;

GSheetInit() async {
  gSheetController = await gSheetInit.spreadsheet(sheetId);
  gSheetCrudUserDetails = await gSheetController.worksheetByTitle('Attendance');
  gSheetEmployeesDetails = await gSheetController.worksheetByTitle('Employees');
}
