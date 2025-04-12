import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class UserService {
  // Get user profile
  static Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseService.firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String userType = userData['userType'] ?? 'student';

      // Get additional user data based on type
      DocumentSnapshot additionalData = await FirebaseService.firestore
          .collection('users')
          .doc(userId)
          .collection('${userType}_data')
          .doc('profile')
          .get();

      if (additionalData.exists) {
        userData.addAll(additionalData.data() as Map<String, dynamic>);
      }

      return userData;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  // Update user profile
  static Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await FirebaseService.firestore
          .collection('users')
          .doc(userId)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Update profile photo
  static Future<String> updateProfilePhoto(
      String userId, String filePath) async {
    try {
      // Upload file to storage
      final ref = FirebaseService.storage
          .ref()
          .child('profile_photos')
          .child('$userId.jpg');
      
      await ref.putFile(filePath as File);
      String photoUrl = await ref.getDownloadURL();

      // Update user document
      await FirebaseService.firestore
          .collection('users')
          .doc(userId)
          .update({'profilePhotoUrl': photoUrl});

      return photoUrl;
    } catch (e) {
      throw Exception('Failed to update profile photo: $e');
    }
  }

  // Search users
  static Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      QuerySnapshot snapshot = await FirebaseService.firestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .limit(10)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'name': data['name'],
          'email': data['email'],
          'profilePhotoUrl': data['profilePhotoUrl'],
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }
}
