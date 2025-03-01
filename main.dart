import 'package:flutter/material.dart';
import 'auth_screens.dart'; // Import the auth screens
import 'main_app.dart'; // Import the main app functionality

void main() {
  runApp(StudyFlowApp());
}

class StudyFlowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Flow',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary color for the app
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Set the initial route to the login page
      initialRoute: '/login',
      // Define the routes for the app
      routes: {
        '/login': (context) => LoginPage(), // Login screen
        '/signup': (context) => SignUpPage(), // Signup screen
        '/student-signup': (context) => StudentSignUpPage(), // Student signup screen
        '/company-signup': (context) => CompanySignUpPage(), // Company signup screen
        '/forgot-password': (context) => ForgotPasswordPage(), // Forgot password screen
        '/reset-password': (context) => ResetPasswordPage(), // Reset password screen
        '/home': (context) => StudyFlowHome(), // Home screen (main app functionality)
      },
    );
  }
}