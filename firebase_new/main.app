import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studyflow/service/firestore_service.dart';
import 'auth_sceens.dart';
import 'auth_screens.dart';
import 'main_app.dart';
import 'firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService().initialize();
  runApp(StudyFlowApp());
}

class StudyFlowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Flow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/student-signup': (context) => StudentSignUpPage(),
        '/company-signup': (context) => CompanySignUpPage(),
        '/forgot-password': (context) => ForgotPasswordPage(),
        '/reset-password': (context) => ResetPasswordPage(),
        '/home': (context) => StudyFlowHome(),
      },
    );
  }
}
