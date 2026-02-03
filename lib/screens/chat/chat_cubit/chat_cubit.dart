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

  // Initialize Chat Room - this creates the room if it doesn't exist
  Future<void> initChatRoom(String targetUserId) async {
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

  // Check if chat room is initialized
  bool isChatRoomInitialized() {
    return currentChatRoomId != null;
  }

  // Method to get messages stream without initializing the room
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getExistingMessagesStream(String targetUserId) async {
    try {
      final roomId = await firebaseRepository.getChatRoomId(targetUserId);
      // Don't store the room ID or emit state - just return the stream temporarily
      return firebaseRepository.getMessages(roomId);
    } catch (e) {
      // Return empty stream if there's an error
      return const Stream.empty();
    }
  }

  // Send Message
  Future<void> sendMessage(String text, {String? targetUserId}) async {
    if (text.trim().isEmpty) return;

    // Initialize chat room if not already initialized
    if (currentChatRoomId == null && targetUserId != null) {
      emit(ChatLoading()); // Show loading while initializing room
      await initChatRoom(targetUserId);
    }

    // If still no chat room ID after initialization attempt, return
    if (currentChatRoomId == null) return;

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

  // Get temporary messages stream for uninitialized rooms
  Stream<QuerySnapshot<Map<String, dynamic>>> getUninitializedMessagesStream(String targetUserId) {
    try {
      // This will trigger room creation, but that's necessary to get messages
      // To truly avoid room creation until first message, we'd need a different approach in the repository
      // For now, we'll just return an empty stream if the room isn't initialized
      return const Stream.empty();
    } catch (e) {
      return const Stream.empty();
    }
  }

  Future<void> markAsSeen() async {
    if (currentChatRoomId != null) {
      await firebaseRepository.markMessagesAsSeen(currentChatRoomId!);
    }
  }
}
