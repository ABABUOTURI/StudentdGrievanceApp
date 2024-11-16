import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive
import 'package:path_provider/path_provider.dart'; // Import Path Provider for Hive directory
import 'package:studentgrievanceapp/Admin/My_Database.dart';
import 'package:studentgrievanceapp/Auth/Getstarted.dart';
import 'package:studentgrievanceapp/Auth/Login.dart';
import 'package:studentgrievanceapp/Auth/Register.dart';
import 'package:studentgrievanceapp/Auth/Resetpass.dart';
import 'package:studentgrievanceapp/Models/user.dart';
import 'package:studentgrievanceapp/students/Academic.dart';
import 'package:studentgrievanceapp/students/Administration.dart';
import 'package:studentgrievanceapp/students/Disciplinary.dart';
import 'package:studentgrievanceapp/students/Harrassment.dart';
import 'package:studentgrievanceapp/students/Notification.dart';
import 'package:studentgrievanceapp/students/grievancereviewstud.dart';
import 'package:studentgrievanceapp/students/submitgrievance.dart';

import 'Models/grievance.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures all bindings are initialized

  // Initialize Hive and Hive Flutter
  await Hive.initFlutter(); 
  Hive.registerAdapter(UserAdapter()); // Register Hive adapter for the User model
  //Hive.registerAdapter(GrievanceSubmissionAdapter()); // For tracking grievance progress
  //Hive.registerAdapter(GrievanceAdapter());

  // Open the Hive box (this will be used to store user data)
  await Hive.openBox<User>('userBox'); 
  //await Hive.openBox<GrievanceSubmission>('grievanceSubmissionBox');
  //await Hive.openBox<Grievance>('grievanceBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Students Grievance App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/getStarted',
      routes: {
        '/getStarted': (context) => GetStartedPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(), // Add the RegistrationPage route
        '/resetPassword': (context) => ResetPasswordPage(),
        '/dashboard': (context) => GrievanceReviewStudentPage(),
        '/submit_grievance': (context) => SubmitGrievancePage(),
        '/academic': (context) => AcademicPage(), // Create this page
        '/administration': (context) => AdministrationPage(), // Create this page
        '/disciplinary': (context) => DisciplinaryPage(), // Create this page
        '/harassment': (context) => HarassmentPage(), // Create this page
        '/notifications': (context) => NotificationPage(),
        '/database': (context) => DatabasePage(), 
      },
      debugShowCheckedModeBanner: false, // This removes the debug banner globally
    );
  }
}