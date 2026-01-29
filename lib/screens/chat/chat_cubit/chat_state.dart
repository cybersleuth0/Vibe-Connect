import "package:chat_app/data/models/message_model.dart";

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatRoomLoaded extends ChatState {
  final String chatroomId;
  ChatRoomLoaded({required this.chatroomId});
}

class ChatMessagesLoaded extends ChatState {
  final List<MessageModel> messages;
  ChatMessagesLoaded({required this.messages});
}

class ChatError extends ChatState {
  final String error;
  ChatError({required this.error});
}
