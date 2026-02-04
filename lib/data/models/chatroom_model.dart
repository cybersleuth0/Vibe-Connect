import "package:cloud_firestore/cloud_firestore.dart";

class ChatRoomModel {
  // 🔑 Static constants for Firebase field names
  static const String KEY_CHATROOM_ID = "chatroomId";
  static const String KEY_PARTICIPANTS = "participants";
  static const String KEY_LAST_MESSAGE = "lastMessage";
  static const String KEY_LAST_MESSAGE_TIME = "lastMessageTime";
  static const String KEY_UNREAD_COUNTS = "unreadCounts";

  // 📦 Properties
  String? chatroomId;
  List<String>? participants;
  String? lastMessage;
  DateTime? lastMessageTime;
  Map<String, int>? unreadCounts;

  ChatRoomModel({this.chatroomId, this.participants, this.lastMessage, this.lastMessageTime, this.unreadCounts});

  // 💾 Convert to Firebase document
  Map<String, dynamic> toDoc() {
    return {
      KEY_CHATROOM_ID: chatroomId,
      KEY_PARTICIPANTS: participants,
      KEY_LAST_MESSAGE: lastMessage,
      KEY_LAST_MESSAGE_TIME: lastMessageTime != null
          ? Timestamp.fromDate(lastMessageTime!)
          : FieldValue.serverTimestamp(),
      KEY_UNREAD_COUNTS: unreadCounts,
    };
  }

  // 📖 Create from Firebase document
  factory ChatRoomModel.fromDoc(Map<String, dynamic> doc) {
    return ChatRoomModel(
      chatroomId: doc[KEY_CHATROOM_ID],
      participants: List<String>.from(doc[KEY_PARTICIPANTS] ?? []),
      lastMessage: doc[KEY_LAST_MESSAGE],
      lastMessageTime: (doc[KEY_LAST_MESSAGE_TIME] as Timestamp?)?.toDate(),
      unreadCounts: (doc[KEY_UNREAD_COUNTS] as Map? ?? {}).map(
        (key, value) => MapEntry(key.toString(), (value as num).toInt()),
      ),
    );
  }
}
