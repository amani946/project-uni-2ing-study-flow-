import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  // Getter for auth instance
  static FirebaseAuth get auth => _auth;

  // Getter for firestore instance
  static FirebaseFirestore get firestore => _firestore;

  // Getter for storage instance
  static FirebaseStorage get storage => _storage;
}
