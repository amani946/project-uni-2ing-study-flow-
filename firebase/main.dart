import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_service.dart';
import 'auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(StudyFlowApp());
}

class StudyFlowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Flow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseService.auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginPage();
          }
          return StudyFlowHome();
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
