import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:vibe_connect/data/models/user_model.dart";

import "../../models/chatroom_model.dart";
import "../../models/message_model.dart";

class FirebaseRepository {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static const String COLLECTION_USERS = "users";
  static const String COLLECTION_CHATROOM = "chatroom";
  static const String COLLECTION_MESSAGES = "messages";

  // User registration

  Future<bool> registerUser({required UserModel user, required String password}) async {
    try {
      final userCred = await firebaseAuth.createUserWithEmailAndPassword(email: user.email!, password: password);

      if (userCred.user != null) {
        user.userId = userCred.user!.uid;
        user.createdAt = DateTime.now().toIso8601String();

        await firebaseFirestore.collection(COLLECTION_USERS).doc(userCred.user!.uid).set(user.toDoc());

        return true; // Return true on success
      } else {
        return false; // Return false if user credential is null
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Update User Data
  Future<void> updateUserData(Map<String, dynamic> data, String userId) async {
    try {
      await firebaseFirestore.collection(COLLECTION_USERS).doc(userId).update(data);
    } catch (e) {
      rethrow;
    }
  }

  // User Login
  Future<UserCredential> loginUser({required String email, required String password}) async {
    try {
      return await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // User Logout
  Future<void> logoutUser() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Fetch all users from firebase

  static Future<QuerySnapshot<Map<String, dynamic>>> getAllUsers() async {
    return await firebaseFirestore.collection(COLLECTION_USERS).get();
  }

  // Get user by id
  static Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String userId) async {
    return await firebaseFirestore.collection(COLLECTION_USERS).doc(userId).get();
  }

  // --- Chat Methods ---

  // 1. Get a unique ChatRoom ID between two users (Synchronous)
  String getChatRoomId(String targetUserId) {
    final String currentUserId = firebaseAuth.currentUser!.uid;

    // To ensure both users end up in the SAME room, we sort their IDs alphabetically.
    final List<String> ids = [currentUserId, targetUserId];
    ids.sort();
    return ids.join("_");
  }

  // 2. Send a Message and update the room's "Last Message" preview
  Future<void> sendMessage({required String targetUserId, required MessageModel message}) async {
    try {
      final String chatroomId = getChatRoomId(targetUserId);
      final String currentUserId = firebaseAuth.currentUser!.uid;

      // Check if this room already exists
      final roomDoc = await firebaseFirestore.collection(COLLECTION_CHATROOM).doc(chatroomId).get();
      final WriteBatch batch = firebaseFirestore.batch();

      if (!roomDoc.exists) {
        final List<String> participants = [currentUserId, targetUserId];
        participants.sort();

        batch.set(firebaseFirestore.collection(COLLECTION_CHATROOM).doc(chatroomId), {
          ChatRoomModel.KEY_CHATROOM_ID: chatroomId,
          ChatRoomModel.KEY_PARTICIPANTS: participants,
          ChatRoomModel.KEY_LAST_MESSAGE: message.text,
          ChatRoomModel.KEY_LAST_MESSAGE_TIME: FieldValue.serverTimestamp(),
          ChatRoomModel.KEY_UNREAD_COUNTS: {
            currentUserId: 0,
            targetUserId: 1, // The receiver starts with 1 unread
          },
        });
      } else {
        // Room exists, update last message and increment unread count for the receiver
        batch.update(firebaseFirestore.collection(COLLECTION_CHATROOM).doc(chatroomId), {
          ChatRoomModel.KEY_LAST_MESSAGE: message.text,
          ChatRoomModel.KEY_LAST_MESSAGE_TIME: FieldValue.serverTimestamp(),
          "${ChatRoomModel.KEY_UNREAD_COUNTS}.$targetUserId": FieldValue.increment(1),
        });
      }

      // Create a reference for a new message document
      final docRef = firebaseFirestore
          .collection(COLLECTION_CHATROOM)
          .doc(chatroomId)
          .collection(COLLECTION_MESSAGES)
          .doc();

      // Assign the generated unique ID to the message object
      message.messageId = docRef.id;

      // Save the actual message data
      batch.set(docRef, message.toDoc());

      // Execute everything together
      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  // 3. Listen to messages in a specific room in real-time
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatroomId) {
    // We point to the "messages" sub-collection inside the specific chat room.
    // We order them by "creationDate" so the newest messages appear correctly.
    // "descending: true" means the newest messages come first in the list.
    return firebaseFirestore
        .collection(COLLECTION_CHATROOM)
        .doc(chatroomId)
        .collection(COLLECTION_MESSAGES)
        .orderBy(MessageModel.KEY_CREATION_DATE, descending: true)
        .snapshots();
  }

  // 4. Mark messages as seen
  Future<void> markMessagesAsSeen(String chatroomId) async {
    try {
      final currentUserId = firebaseAuth.currentUser!.uid;

      // Get all messages in this room that are NOT seen
      final snapshot = await firebaseFirestore
          .collection(COLLECTION_CHATROOM)
          .doc(chatroomId)
          .collection(COLLECTION_MESSAGES)
          .where(MessageModel.KEY_SEEN, isEqualTo: false)
          .get();

      final WriteBatch batch = firebaseFirestore.batch();

      for (var doc in snapshot.docs) {
        // Only mark messages sent by the OTHER person as seen
        if (doc.get(MessageModel.KEY_SENDER_ID) != currentUserId) {
          batch.update(doc.reference, {MessageModel.KEY_SEEN: true});
        }
      }

      // Reset unread count for the current user
      batch.update(firebaseFirestore.collection(COLLECTION_CHATROOM).doc(chatroomId), {
        "${ChatRoomModel.KEY_UNREAD_COUNTS}.$currentUserId": 0,
      });

      await batch.commit();
    } catch (e) {
      // Log error or ignore
      debugPrint("Error marking messages as seen: $e");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChatRooms() {
    final String currentUserId = firebaseAuth.currentUser!.uid;
    return firebaseFirestore
        .collection(COLLECTION_CHATROOM)
        .where(ChatRoomModel.KEY_PARTICIPANTS, arrayContains: currentUserId)
        .orderBy(ChatRoomModel.KEY_LAST_MESSAGE_TIME, descending: true)
        .snapshots();
  }
}
