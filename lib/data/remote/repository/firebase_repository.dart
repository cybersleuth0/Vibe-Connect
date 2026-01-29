import "package:chat_app/data/models/user_model.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

import "../../models/message_model.dart";
import "../../models/chatroom_model.dart";

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

  // --- Chat Methods ---

  // 1. Get or Create a unique ChatRoom between two users
  Future<String> getChatRoomId(String targetUserId) async {
    final String currentUserId = firebaseAuth.currentUser!.uid;

    // To ensure both users end up in the SAME room, we sort their IDs alphabetically.
    // This way, Ayush_John and John_Ayush both become "Ayush_John".

    final List<String> ids = [currentUserId, targetUserId];
    ids.sort();
    final String chatroomId = ids.join("_");

    // Check if this room already exists in our "chatroom" collection
    final roomDoc = await firebaseFirestore.collection(COLLECTION_CHATROOM).doc(chatroomId).get();

    if (!roomDoc.exists) {
      // If the room doesn't exist, we create it with initial metadata
      await firebaseFirestore.collection(COLLECTION_CHATROOM).doc(chatroomId).set({
        ChatRoomModel.KEY_CHATROOM_ID: chatroomId,
        ChatRoomModel.KEY_PARTICIPANTS: ids,
        ChatRoomModel.KEY_LAST_MESSAGE: "",
        ChatRoomModel.KEY_LAST_MESSAGE_TIME: FieldValue.serverTimestamp(),
        ChatRoomModel.KEY_UNREAD_COUNTS: {currentUserId: 0, targetUserId: 0},
      });
    }

    return chatroomId;
  }

  // 2. Send a Message and update the room's "Last Message" preview
  Future<void> sendMessage({required String chatroomId, required MessageModel message}) async {
    try {
      // Create a reference for a new message document (generates a random unique ID)
      // Path: chatroom -> {chatroomId} -> messages -> {random_msg_id}

      final docRef = firebaseFirestore
          .collection(COLLECTION_CHATROOM)
          .doc(chatroomId)
          .collection(COLLECTION_MESSAGES)
          .doc();

      // Assign the generated unique ID to the message object
      message.messageId = docRef.id;

      // We use a WriteBatch to perform two updates at the same time (atomically).
      // This ensures data consistency: the message is saved AND the preview is updated.
      final WriteBatch batch = firebaseFirestore.batch();

      // Step 1: Save the actual message data in the sub-collection
      batch.set(docRef, message.toDoc());

      // Step 2: Update the outer ChatRoom document with the latest message text and time.

      // This is used to show the "Last Message" on the Home Screen chat list.
      batch.update(firebaseFirestore.collection(COLLECTION_CHATROOM).doc(chatroomId), {
        ChatRoomModel.KEY_LAST_MESSAGE: message.text,
        ChatRoomModel.KEY_LAST_MESSAGE_TIME: FieldValue.serverTimestamp(),
      });

      // Execute both actions together
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
}
