import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class PostService {
  // Create a new post
  static Future<void> createPost({
    required String userId,
    required String username,
    required String content,
  }) async {
    try {
      // Extract hashtags from content
      final hashtags = _extractHashtags(content);

      await FirebaseService.firestore.collection('posts').add({
        'userId': userId,
        'username': username,
        'content': content,
        'likes': 0,
        'comments': [],
        'hashtags': hashtags,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  // Get posts feed
  static Stream<QuerySnapshot> getPostsFeed() {
    return FirebaseService.firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get posts by hashtag
  static Stream<QuerySnapshot> getPostsByHashtag(String hashtag) {
    return FirebaseService.firestore
        .collection('posts')
        .where('hashtags', arrayContains: hashtag)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Like a post
  static Future<void> likePost(String postId, String userId) async {
    try {
      final postRef = FirebaseService.firestore.collection('posts').doc(postId);

      await FirebaseService.firestore.runTransaction((transaction) async {
        final postDoc = await transaction.get(postRef);
        if (!postDoc.exists) {
          throw Exception('Post not found');
        }

        final postData = postDoc.data() as Map<String, dynamic>;
        final likes = postData['likes'] ?? 0;
        final likedBy = postData['likedBy'] ?? [];

        if (likedBy.contains(userId)) {
          // User already liked, unlike it
          transaction.update(postRef, {
            'likes': likes - 1,
            'likedBy': FieldValue.arrayRemove([userId]),
          });
        } else {
          // Like the post
          transaction.update(postRef, {
            'likes': likes + 1,
            'likedBy': FieldValue.arrayUnion([userId]),
          });
        }
      });
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

  // Add comment to post
  static Future<void> addComment({
    required String postId,
    required String userId,
    required String username,
    required String text,
  }) async {
    try {
      final comment = {
        'userId': userId,
        'username': username,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseService.firestore
          .collection('posts')
          .doc(postId)
          .update({
        'comments': FieldValue.arrayUnion([comment]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  // Extract hashtags from text
  static List<String> _extractHashtags(String text) {
    final regex = RegExp(r'#\w+');
    final matches = regex.allMatches(text);
    return matches.map((match) => match.group(0)!).toSet().toList();
  }
}
