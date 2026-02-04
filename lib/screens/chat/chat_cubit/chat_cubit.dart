import "package:vibe_connect/data/models/message_model.dart";
import "package:vibe_connect/data/remote/repository/firebase_repository.dart";
import "package:vibe_connect/screens/chat/chat_cubit/chat_state.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ChatCubit extends Cubit<ChatState> {
  final FirebaseRepository firebaseRepository;

  ChatCubit({required this.firebaseRepository}) : super(ChatInitial());

  String? currentChatRoomId;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _messagesStream;

  // Initialize Chat Room - this gets the room ID and starts listening
  void initChatRoom(String targetUserId) {
    try {
      final roomId = firebaseRepository.getChatRoomId(targetUserId);
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
  Future<void> sendMessage(String text, {String? targetUserId}) async {
    if (text.trim().isEmpty) return;

    // We need a targetUserId if the room isn't initialized yet
    final String? effectiveTargetUserId = targetUserId;

    if (currentChatRoomId == null && effectiveTargetUserId != null) {
      initChatRoom(effectiveTargetUserId);
    }

    if (currentChatRoomId == null || effectiveTargetUserId == null) return;

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
      await firebaseRepository.sendMessage(targetUserId: effectiveTargetUserId, message: message);
    } catch (e) {
      // Don't emit error state here as it would replace the chat UI
    }
  }

  // Get Messages Stream
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStream() {
    return _messagesStream ?? const Stream.empty();
  }

  Future<void> markAsSeen() async {
    if (currentChatRoomId != null) {
      await firebaseRepository.markMessagesAsSeen(currentChatRoomId!);
    }
  }
}
