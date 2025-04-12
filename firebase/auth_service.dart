import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_service.dart';

class AuthService {
  // Sign in with email and password
  static Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await FirebaseService.auth
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Register a student
  static Future<User?> registerStudent({
    required String email,
    required String password,
    required String name,
    required String university,
    required String major,
    required String country,
  }) async {
    try {
      // Create user
      UserCredential credential = await FirebaseService.auth
          .createUserWithEmailAndPassword(email: email, password: password);
      
      // Add user data to Firestore
      await FirebaseService.firestore
          .collection('users')
          .doc(credential.user?.uid)
          .set({
        'email': email,
        'name': name,
        'userType': 'student',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Add student-specific data
      await FirebaseService.firestore
          .collection('users')
          .doc(credential.user?.uid)
          .collection('student_data')
          .doc('profile')
          .set({
        'university': university,
        'major': major,
        'country': country,
      });

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Register a company
  static Future<User?> registerCompany({
    required String email,
    required String password,
    required String companyName,
    required String domainOfWork,
    required String companyType,
    required String commercialRegister,
    required String country,
  }) async {
    try {
      // Create user
      UserCredential credential = await FirebaseService.auth
          .createUserWithEmailAndPassword(email: email, password: password);
      
      // Add user data to Firestore
      await FirebaseService.firestore
          .collection('users')
          .doc(credential.user?.uid)
          .set({
        'email': email,
        'name': companyName,
        'userType': 'company',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Add company-specific data
      await FirebaseService.firestore
          .collection('users')
          .doc(credential.user?.uid)
          .collection('company_data')
          .doc('profile')
          .set({
        'domainOfWork': domainOfWork,
        'companyType': companyType,
        'commercialRegister': commercialRegister,
        'country': country,
      });

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Password reset
  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseService.auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign out
  static Future<void> signOut() async {
    await FirebaseService.auth.signOut();
  }

  // Get current user
  static User? getCurrentUser() {
    return FirebaseService.auth.currentUser;
  }

  // Handle auth errors
  static String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The email address is already in use.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An unknown error occurred.';
    }
  }
}
