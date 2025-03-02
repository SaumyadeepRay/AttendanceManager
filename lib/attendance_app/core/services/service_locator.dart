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
    "type": "service_account",
    "project_id": "attendance-manager-task",
    "private_key_id": "4bb9c6ccec3d66d18c4dff9adacfe26d6afbe11e",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC+jx/X6HK3yM5K\nFYVglIAttC4zESjkGyrEH1Ehilx6eD9pWwfowOP6V9zoEEXHPpUO4D204px0KbGY\nVKYLpDbnEZDcQQtk1SBYCLGgR+tXM/JXgICdXXIRl+2hfbRRjGlGkYubtA2Pib9B\nt/j0NSVzh/GwVv2UYbLQaDReALisZWlfCCrhFrcjY0yrj/vSMQa5nbu0/ET0o934\nClTnDQqMry0eeHYxCQWl0U7vCIKUK8/G2eL3Ugj6oNFhfmb0jRLrBwxCMw8u6r78\nl9iaRACQFs8320ArEe9IhGD4onbuPBkApnvChV2HIaxwabncI2Tfewut1TitC4Zg\nWuMmj6eRAgMBAAECggEABMJ4izUYsfFZoTk1w1R8OeAEcCU5ZC6vSBYn6a59+jdh\nDpet7DTusNLjXzbCVmxgTt6AHhGzspVUxLM3EUb/EdETESRNBX4LDHXdoW0wcjV3\ng/LfS4bxLaIxxtkH4SpQmhkSL4+9D7jzInAm30spSgAjE9ptY6iXzbuvlKpAEpq8\nEP3pcg5a9DFonQJaWCvYA73rmwSUot7jpqms8TsPE6OubROYpSVfOZe3K6nzOkcx\n32hR/ht/Q8FvgScgzvPVFKCL+p8QH1wyszgkEsG2NScZ8nTMTn9HsNjK3ShvhFq0\ncUDGao93cO3uGPcMd0s0QjkyjWowqqRLlFNjpcr74QKBgQDfCfLpKsniPbNc5Etm\n7yCrtxyZU4tkRQvQVCs1gG8YKKIlZxxaboB17NbT/DAEVkQu9RUtsMLBS1dACwD0\nkuJa/GvOQ7nMpax3HRnQdF1RI/Y20zDzU/LH4+i4bOQhdw1r0s7cYKlHkSYHfuio\nqyLcADKBVFuN/4aCaQeyNcgbYQKBgQDauGTR5ge0s+YO5Komc9xqNIysHuM5JsJD\n6zFbfRkJONZVGToUHhjNWHnPBGGsbdSudUrbbSuDgNjyMpZvpFDRkRXGv//OBzG9\nmTNUX+qKuynMAKejt6n/mfCEAeDZWrlMfO5/Vp40QhEuybMfY4xHtUoysfQva5P5\niZpfRZSqMQKBgQCEktpTZD6p/vjdT0nOfncR+n7CWJlzWWNDSrSAUb43QvfWeaqt\nyh8LeWLckHtOKKTQsJcNGJM65/iNtby0o5ZudLnz2efXz+Zqyt5sPK63K0QPpIrl\nJ9IYpMzQytDzX1uX6q9Q6RfV1V4geHv8vfSzhl5+51CgX/FpFNshP7yZIQKBgQCz\nGj/k6brxrEb9dx4l8sZRacqvv3NN/4Eg4N1AD8aKmLJaaRf4FVU2AfdtICdjbWS1\nn3K3EESLoN0GJ4qszR8pHOd6Iws0CQwgN+2icBC9ndnyJa8hD2rz1XjwgCFBm1sV\nWVBrkeBm5prvd1doorniln+116cflbZMpvN0hKPiYQKBgCbObPpWI3OXPV8bi1Qn\nhfvP4IjAd1qmajJHCCm4DHwzViWzEc60acSTkBHb/GFOSeApavF+i/s5H4HJqlFt\nxm654E51hlMQAuQbc3tPELRzxuBBj9AoE3woX2pa1RHxHdagqlPXOPH4+2euefCs\nqGUtgdSloQ5scDfuDDyWWDZ3\n-----END PRIVATE KEY-----\n",
    "client_email": "attendance-manager@attendance-manager-task.iam.gserviceaccount.com",
    "client_id": "113886396371258873420",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/attendance-manager%40attendance-manager-task.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
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
      remoteDataSource: sl(),
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

// Future<SheetsApi> getSheetsApi() async {
//   final _scopes = [SheetsApi.spreadsheetsScope];
//
//   var client = await clientViaUserConsent(
//     ClientId('814341164557-jid8mto7sdoh4b5a26gjbcbtgr1lgohm.apps.googleusercontent.com', ''),
//     _scopes,
//     (url) {
//       print('Please visit the following URL to authenticate:');
//       print('  => $url');
//       print('');
//     },
//   );
//
//   return SheetsApi(client);
// }
