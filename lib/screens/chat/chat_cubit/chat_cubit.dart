import "package:chat_app/data/models/message_model.dart";
import "package:chat_app/data/remote/repository/firebase_repository.dart";
import "package:chat_app/screens/chat/chat_cubit/chat_state.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ChatCubit extends Cubit<ChatState> {
  final FirebaseRepository firebaseRepository;

  ChatCubit({required this.firebaseRepository}) : super(ChatInitial());

  String? currentChatRoomId;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _messagesStream;

  // Initialize Chat Room
  Future<void> initChatRoom(String targetUserId) async {
    // Only show loading if we haven't loaded this room yet
    if (currentChatRoomId == null) {
      emit(ChatLoading());
    }

    try {
      final roomId = await firebaseRepository.getChatRoomId(targetUserId);
      if (currentChatRoomId != roomId) {
        currentChatRoomId = roomId;
        _messagesStream = firebaseRepository.getMessages(roomId);
        emit(ChatRoomLoaded(chatroomId: roomId));
      }
    } catch (e) {
      emit(ChatError(error: e.toString()));
    }
  }

  // Send Message
  Future<void> sendMessage(String text) async {
    if (currentChatRoomId == null || text.trim().isEmpty) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final message = MessageModel(
      senderId: currentUser.uid,
      text: text.trim(),
      creationDate: DateTime.now(),
      seen: false,
      type: "text",
    );

    try {
      await firebaseRepository.sendMessage(chatroomId: currentChatRoomId!, message: message);
    } catch (e) {
      // Don't emit error state here as it would replace the chat UI
      // Use a separate side-effect mechanism or just log it
    }
  }

  // Get Messages Stream
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStream() {
    return _messagesStream ?? const Stream.empty();
  }
}
