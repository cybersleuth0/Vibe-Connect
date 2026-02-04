abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatRoomLoaded extends ChatState {
  final String chatroomId;
  ChatRoomLoaded({required this.chatroomId});
}

class ChatError extends ChatState {
  final String error;
  ChatError({required this.error});
}
