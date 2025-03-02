import 'package:flutter/material.dart'; // Core Flutter package for building UI
import 'package:flutter_bloc/flutter_bloc.dart'; // BLoC package for state management
import 'attendance_app/core/services/service_locator.dart';
import 'attendance_app/features/attendance/presentation/bloc/attendance_bloc.dart'; // Import Attendance BLoC
import 'attendance_app/features/attendance/presentation/screens/home_screen.dart'; // Import Home Screen
import 'attendance_app/features/employee/presentation/bloc/employee_bloc.dart'; // Import Employee BLoC

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  await GSheetInit(); // Initialize dependency injection setup to register services and BLoCs
  runApp(const MyApp()); // Start the Flutter app by calling MyApp widget
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Provide multiple BLoC instances to the widget tree
      providers: [
        BlocProvider(
          create: (_) => sl<AttendanceBloc>(),
        ), // Inject AttendanceBloc
        BlocProvider(
          create: (_) => sl<EmployeeBloc>(),
        ), // Inject EmployeeBloc
      ],
      child: MaterialApp(
        title: 'Attendance Manager', // App title
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ), // Theme color setup
          useMaterial3: true, // Enable Material 3 design features
        ),
        home: const HomeScreen(),
        // initialRoute: '/attendance', // Set initial screen route
        // routes: {
        //   '/attendance': (context) => const HomeScreen(), // Map '/attendance' route to HomeScreen
        //   '/employees': (context) => const EmployeeListScreen(), // Map '/employees' route to EmployeeListScreen
        // },
      ),
    );
  }
}
