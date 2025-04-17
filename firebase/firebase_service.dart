import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance; // Fixed this line

  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  // User Authentication Methods
  static Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Sign in error: $e");
      return null;
    }
  }

  static Future<User?> registerStudent({
    required String name,
    required String email,
    required String password,
    required String country,
    required String university,
    required String major,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await firestore.collection('students').doc(userCredential.user?.uid).set({
        'name': name,
        'email': email,
        'country': country,
        'university': university,
        'major': major,
        'createdAt': FieldValue.serverTimestamp(),
        'profilePhotoUrl': '',
        'bio': '',
        'socialMedia': '',
      });

      return userCredential.user;
    } catch (e) {
      print("Registration error: $e");
      return null;
    }
  }

  static Future<User?> registerCompany({
    required String companyName,
    required String email,
    required String password,
    required String domain,
    required String companyType,
    required String commercialRegister,
    required String country,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await firestore.collection('companies').doc(userCredential.user?.uid).set({
        'companyName': companyName,
        'email': email,
        'domain': domain,
        'companyType': companyType,
        'commercialRegister': commercialRegister,
        'country': country,
        'createdAt': FieldValue.serverTimestamp(),
        'logoUrl': '',
        'description': '',
        'website': '',
      });

      return userCredential.user;
    } catch (e) {
      print("Company registration error: $e");
      return null;
    }
  }

  static Future<void> signOut() async {
    await auth.signOut();
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Password reset error: $e");
      throw e;
    }
  }

  // User Data Methods
  static Future<Map<String, dynamic>?> getCurrentUserData() async {
    User? user = auth.currentUser;
    if (user == null) return null;

    // Check if user is a student
    DocumentSnapshot studentDoc = await firestore.collection('students').doc(user.uid).get();
    if (studentDoc.exists) {
      return studentDoc.data() as Map<String, dynamic>;
    }

    // Check if user is a company
    DocumentSnapshot companyDoc = await firestore.collection('companies').doc(user.uid).get();
    if (companyDoc.exists) {
      return companyDoc.data() as Map<String, dynamic>;
    }

    return null;
  }

  static Future<void> updateStudentProfile({
    required String userId,
    String? bio,
    String? socialMedia,
    String? profilePhotoUrl,
  }) async {
    Map<String, dynamic> updateData = {};
    if (bio != null) updateData['bio'] = bio;
    if (socialMedia != null) updateData['socialMedia'] = socialMedia;
    if (profilePhotoUrl != null) updateData['profilePhotoUrl'] = profilePhotoUrl;

    if (updateData.isNotEmpty) {
      await firestore.collection('students').doc(userId).update(updateData);
    }
  }

  static Future<void> updateCompanyProfile({
    required String userId,
    String? description,
    String? website,
    String? logoUrl,
  }) async {
    Map<String, dynamic> updateData = {};
    if (description != null) updateData['description'] = description;
    if (website != null) updateData['website'] = website;
    if (logoUrl != null) updateData['logoUrl'] = logoUrl;

    if (updateData.isNotEmpty) {
      await firestore.collection('companies').doc(userId).update(updateData);
    }
  }

  // Post Methods
  static Future<void> createPost({
    required String userId,
    required String content,
    required bool isStudent,
  }) async {
    await firestore.collection('posts').add({
      'userId': userId,
      'content': content,
      'isStudent': isStudent,
      'likes': 0,
      'comments': [],
      'createdAt': FieldValue.serverTimestamp(),
      'hashtags': _extractHashtags(content),
    });
  }

  static Future<void> likePost(String postId, String userId) async {
    await firestore.collection('posts').doc(postId).update({
      'likes': FieldValue.increment(1),
      'likedBy': FieldValue.arrayUnion([userId]),
    });
  }

  static Future<void> unlikePost(String postId, String userId) async {
    await firestore.collection('posts').doc(postId).update({
      'likes': FieldValue.increment(-1),
      'likedBy': FieldValue.arrayRemove([userId]),
    });
  }

  static Future<void> addComment(String postId, String userId, String comment) async {
    await firestore.collection('posts').doc(postId).update({
      'comments': FieldValue.arrayUnion([
        {
          'userId': userId,
          'comment': comment,
          'createdAt': FieldValue.serverTimestamp(),
        }
      ]),
    });
  }

  static Future<void> savePost(String postId, String userId) async {
    await firestore.collection('users').doc(userId).update({
      'savedPosts': FieldValue.arrayUnion([postId]),
    });
  }

  static Future<void> unsavePost(String postId, String userId) async {
    await firestore.collection('users').doc(userId).update({
      'savedPosts': FieldValue.arrayRemove([postId]),
    });
  }

  // Helper Methods
  static List<String> _extractHashtags(String content) {
    RegExp regex = RegExp(r'\B#\w*[a-zA-Z]+\w*');
    Iterable<Match> matches = regex.allMatches(content);
    return matches.map((match) => match.group(0)!).toList();
  }

  // Storage Methods
  static Future<String> uploadProfilePhoto(String userId, String filePath) async {
    try {
      Reference ref = storage.ref().child('profile_photos/$userId');
      await ref.putFile(File(filePath));
      return await ref.getDownloadURL();
    } catch (e) {
      print("Photo upload error: $e");
      throw e;
    }
  }
}
