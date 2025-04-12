import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class ChatService {
  // Get or create a chat between two users
  static Future<String> getOrCreateChat(String userId1, String userId2) async {
    try {
      // Check if chat already exists
      QuerySnapshot snapshot = await FirebaseService.firestore
          .collection('chats')
          .where('participants', arrayContains: userId1)
          .get();

      for (var doc in snapshot.docs) {
        List<dynamic> participants = doc['participants'];
        if (participants.contains(userId2)) {
          return doc.id;
        }
      }

      // Create new chat
      DocumentReference chatRef = await FirebaseService.firestore
          .collection('chats')
          .add({
            'participants': [userId1, userId2],
            'lastMessage': '',
            'lastMessageTime': FieldValue.serverTimestamp(),
            'createdAt': FieldValue.serverTimestamp(),
          });

      return chatRef.id;
    } catch (e) {
      throw Exception('Failed to get or create chat: $e');
    }
  }

  // Send a message
  static Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    try {
      // Add message to subcollection
      await FirebaseService.firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
            'senderId': senderId,
            'senderName': senderName,
            'text': text,
            'timestamp': FieldValue.serverTimestamp(),
            'read': false,
          });

      // Update chat's last message
      await FirebaseService.firestore
          .collection('chats')
          .doc(chatId)
          .update({
            'lastMessage': text,
            'lastMessageTime': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Get chat messages
  static Stream<QuerySnapshot> getChatMessages(String chatId) {
    return FirebaseService.firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Get user chats
  static Stream<QuerySnapshot> getUserChats(String userId) {
    return FirebaseService.firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // Mark messages as read
  static Future<void> markMessagesAsRead(String chatId, String userId) async {
    try {
      QuerySnapshot messages = await FirebaseService.firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('senderId', isNotEqualTo: userId)
          .where('read', isEqualTo: false)
          .get();

      WriteBatch batch = FirebaseService.firestore.batch();
      
      for (var doc in messages.docs) {
        batch.update(doc.reference, {'read': true});
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark messages as read: $e');
    }
  }
}
