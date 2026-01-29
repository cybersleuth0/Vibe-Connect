import "package:cloud_firestore/cloud_firestore.dart";

class ChatRoomModel {
  String? chatroomId;
  List<String>? participants;
  String? lastMessage;
  DateTime? lastMessageTime;
  Map<String, int>? unreadCounts; // Map of userId: count

  ChatRoomModel({this.chatroomId, this.participants, this.lastMessage, this.lastMessageTime, this.unreadCounts});

  Map<String, dynamic> toDoc() {
    return {
      "chatroomId": chatroomId,
      "participants": participants,
      "lastMessage": lastMessage,
      "lastMessageTime": lastMessageTime != null ? Timestamp.fromDate(lastMessageTime!) : FieldValue.serverTimestamp(),
      "unreadCounts": unreadCounts,
    };
  }

  factory ChatRoomModel.fromDoc(Map<String, dynamic> doc) {
    return ChatRoomModel(
      chatroomId: doc["chatroomId"],
      participants: List<String>.from(doc["participants"] ?? []),
      lastMessage: doc["lastMessage"],
      lastMessageTime: (doc["lastMessageTime"] as Timestamp?)?.toDate(),
      unreadCounts: Map<String, int>.from(doc["unreadCounts"] ?? {}),
    );
  }
}
