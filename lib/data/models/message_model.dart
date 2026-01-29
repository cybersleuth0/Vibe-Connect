import "package:cloud_firestore/cloud_firestore.dart";

class MessageModel {
  String? messageId;
  String? senderId;
  String? text;
  bool seen = false;
  DateTime? creationDate;
  String? type; // "text", "image", "audio"

  MessageModel({this.messageId, this.senderId, this.text, this.seen = false, this.creationDate, this.type = "text"});

  Map<String, dynamic> toDoc() {
    return {
      "messageId": messageId,
      "senderId": senderId,
      "text": text,
      "seen": seen,
      "creationDate": creationDate != null ? Timestamp.fromDate(creationDate!) : FieldValue.serverTimestamp(),
      "type": type,
    };
  }

  factory MessageModel.fromDoc(Map<String, dynamic> doc) {
    return MessageModel(
      messageId: doc["messageId"],
      senderId: doc["senderId"],
      text: doc["text"],
      seen: doc["seen"] ?? false,
      creationDate: (doc["creationDate"] as Timestamp?)?.toDate(),
      type: doc["type"] ?? "text",
    );
  }
}
