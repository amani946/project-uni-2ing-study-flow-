import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize Firebase
  Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  // Auth methods
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      debugPrint('Error signing in: $e');
      return null;
    }
  }

  Future<User?> signUpStudent({
    required String email,
    required String password,
    required String name,
    required String country,
    required String university,
    required String major,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'type': 'student',
          'name': name,
          'email': email,
          'country': country,
          'university': university,
          'major': major,
          'profile_picture': '',
          'bio': '',
          'social_links': [],
          'created_at': FieldValue.serverTimestamp(),
        });
      }

      return userCredential.user;
    } catch (e) {
      debugPrint('Error signing up student: $e');
      return null;
    }
  }

  Future<User?> signUpCompany({
    required String email,
    required String password,
    required String name,
    required String country,
    required String companyName,
    required String domain,
    required String companyType,
    required String registrationNumber,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'type': 'company',
          'name': name,
          'email': email,
          'country': country,
          'company_name': companyName,
          'domain': domain,
          'company_type': companyType,
          'registration_number': registrationNumber,
          'profile_picture': '',
          'bio': '',
          'social_links': [],
          'created_at': FieldValue.serverTimestamp(),
        });
      }

      return userCredential.user;
    } catch (e) {
      debugPrint('Error signing up company: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // User data methods
  Future<DocumentSnapshot> getUserData(String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }

  Future<void> updateUserProfile({
    required String userId,
    String? bio,
    String? socialLink,
    String? profilePicture,
  }) async {
    Map<String, dynamic> updateData = {};

    if (bio != null) updateData['bio'] = bio;
    if (socialLink != null) {
      await _firestore.collection('users').doc(userId).update({
        'social_links': FieldValue.arrayUnion([socialLink]),
      });
    }
    if (profilePicture != null) updateData['profile_picture'] = profilePicture;

    if (updateData.isNotEmpty) {
      await _firestore.collection('users').doc(userId).update(updateData);
    }
  }

  // Post methods
  Future<void> createPost({
    required String userId,
    required String content,
    String? imageUrl,
    List<String>? hashtags,
  }) async {
    await _firestore.collection('posts').add({
      'user_id': userId,
      'content': content,
      'image': imageUrl ?? '',
      'created_at': FieldValue.serverTimestamp(),
      'likes': {},
      'comments': {},
      'saved': {},
      'hashtags': hashtags != null
          ? {for (var hashtag in hashtags) hashtag: {'name': hashtag}}
          : {},
    });
  }

  Future<void> likePost(String postId, String userId) async {
    await _firestore.collection('posts').doc(postId).update({
      'likes.$userId': {
        'user_id': userId,
        'created_at': FieldValue.serverTimestamp(),
      },
    });
  }

  Future<void> unlikePost(String postId, String userId) async {
    await _firestore.collection('posts').doc(postId).update({
      'likes.$userId': FieldValue.delete(),
    });
  }

  Future<void> addComment(String postId, String userId, String content) async {
    final commentId = _firestore.collection('posts').doc().id;
    await _firestore.collection('posts').doc(postId).update({
      'comments.$commentId': {
        'user_id': userId,
        'content': content,
        'created_at': FieldValue.serverTimestamp(),
      },
    });
  }

  // Friendship methods
  Future<void> sendFriendRequest(String senderId, String receiverId) async {
    final friendshipId = 'friendship_${senderId}_$receiverId';
    await _firestore.collection('friendships').doc(friendshipId).set({
      'sender_id': senderId,
      'receiver_id': receiverId,
      'status': 'pending',
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  // Message methods
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
    String? fileUrl,
  }) async {
    await _firestore.collection('messages').add({
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'file': fileUrl,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  // Internship methods
  Future<void> createInternship({
    required String companyId,
    required String title,
    required String description,
    required List<String> skillsRequired,
    String? link,
  }) async {
    await _firestore.collection('internships').add({
      'company_id': companyId,
      'title': title,
      'description': description,
      'skills_required': skillsRequired,
      'link': link ?? '',
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  // Scholarship methods
  Future<void> createScholarship({
    required String university,
    required String title,
    required String description,
    required List<String> skillsRequired,
    String? link,
  }) async {
    await _firestore.collection('scholarships').add({
      'university': university,
      'title': title,
      'description': description,
      'skills_required': skillsRequired,
      'link': link ?? '',
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  // Todo methods
  Future<void> addTodo({
    required String userId,
    required String task,
    required String status,
    DateTime? dueDate,
  }) async {
    await _firestore.collection('todos').add({
      'user_id': userId,
      'task': task,
      'status': status,
      'due_date': dueDate,
    });
  }

  // Streams for real-time updates
  Stream<QuerySnapshot> getPostsStream() {
    return _firestore
        .collection('posts')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserPostsStream(String userId) {
    return _firestore
        .collection('posts')
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> getUserStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots();
  }

  Stream<QuerySnapshot> getMessagesStream(String userId1, String userId2) {
    return _firestore
        .collection('messages')
        .where('sender_id', whereIn: [userId1, userId2])
        .where('receiver_id', whereIn: [userId1, userId2])
        .orderBy('created_at', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getInternshipsStream() {
    return _firestore
        .collection('internships')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getScholarshipsStream() {
    return _firestore
        .collection('scholarships')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserTodosStream(String userId) {
    return _firestore
        .collection('todos')
        .where('user_id', isEqualTo: userId)
        .orderBy('due_date', descending: false)
        .snapshots();
  }
}
