import "package:cloud_firestore/cloud_firestore.dart";

class MessageModel {
  // 🔑 Static constants
  static const String KEY_MESSAGE_ID = "messageId";
  static const String KEY_SENDER_ID = "senderId";
  static const String KEY_TEXT = "text";
  static const String KEY_SEEN = "seen";
  static const String KEY_CREATION_DATE = "creationDate";
  static const String KEY_TYPE = "type";

  // 📦 Properties
  String? messageId;
  String? senderId;
  String? text;
  bool seen = false;
  DateTime? creationDate;
  String? type;

  MessageModel({this.messageId, this.senderId, this.text, this.seen = false, this.creationDate, this.type = "text"});

  Map<String, dynamic> toDoc() {
    return {
      KEY_MESSAGE_ID: messageId,
      KEY_SENDER_ID: senderId,
      KEY_TEXT: text,
      KEY_SEEN: seen,
      KEY_CREATION_DATE: creationDate != null ? Timestamp.fromDate(creationDate!) : FieldValue.serverTimestamp(),
      KEY_TYPE: type,
    };
  }

  factory MessageModel.fromDoc(Map<String, dynamic> doc) {
    return MessageModel(
      messageId: doc[KEY_MESSAGE_ID],
      senderId: doc[KEY_SENDER_ID],
      text: doc[KEY_TEXT],
      seen: doc[KEY_SEEN] ?? false,
      creationDate: (doc[KEY_CREATION_DATE] as Timestamp?)?.toDate(),
      type: doc[KEY_TYPE] ?? "text",
    );
  }
}
