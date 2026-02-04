import "dart:async";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../data/models/chatroom_model.dart";
import "../../../data/models/user_model.dart";
import "../../../data/remote/repository/firebase_repository.dart";
import "home_state.dart";

class HomeCubit extends Cubit<HomeState> {
  final FirebaseRepository firebaseRepository;
  StreamSubscription? _chatRoomsSubscription;

  // Cache to store user data and avoid redundant fetches
  final Map<String, UserModel> _userCache = {};

  HomeCubit({required this.firebaseRepository}) : super(HomeInitial());

  void loadChatRooms() {
    // STEP 1: Tell the UI to show a loading spinner
    emit(HomeLoading());

    // STEP 2: Cancel any old "listener" before starting a new one to avoid memory leaks
    _chatRoomsSubscription?.cancel();

    // STEP 3: Start "listening" to the ChatRooms collection in real-time
    _chatRoomsSubscription = firebaseRepository.getUserChatRooms().listen(
      (snapshot) async {
        try {
          // STEP 4: Identify who the currently logged-in user is
          final currentUserId = FirebaseAuth.instance.currentUser?.uid;
          if (currentUserId == null) return;

          final List<ChatRoomWithUser> chatRoomsWithUsers = [];

          // STEP 5: Loop through every "ChatRoom" envelope received from Firebase
          for (var doc in snapshot.docs) {
            final chatRoom = ChatRoomModel.fromDoc(doc.data());

            // STEP 6: Find the ID of the "other" person (the one you are chatting with)
            final otherUserId = chatRoom.participants?.firstWhere((id) => id != currentUserId, orElse: () => "");

            if (otherUserId != null && otherUserId.isNotEmpty) {
              // STEP 7: Check our "Notebook" (Cache) first to see if we already know this user
              UserModel? user = _userCache[otherUserId];

              // If they are NOT in the notebook, we fetch them from Firebase
              if (user == null) {
                final userDoc = await FirebaseRepository.getUser(otherUserId);
                if (userDoc.exists) {
                  user = UserModel.fromDoc(userDoc.data()!);
                  // Save them in the notebook so we don't have to ask Firebase again next time
                  _userCache[otherUserId] = user;
                }
              }

              // STEP 8: Staple the ChatRoom and User data together into one object
              if (user != null) {
                chatRoomsWithUsers.add(ChatRoomWithUser(chatRoom: chatRoom, user: user));
              }
            }
          }

          // STEP 9: Shouted the final, complete list to the UI to be displayed
          emit(HomeLoaded(chatRooms: chatRoomsWithUsers));
        } catch (e) {
          // If anything goes wrong, tell the UI to show an error message
          emit(HomeError(error: e.toString()));
        }
      },
      onError: (error) {
        emit(HomeError(error: error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    // STEP 10: Turn off the "Walkie-Talkie" (Subscription) when this screen is destroyed
    _chatRoomsSubscription?.cancel();
    return super.close();
  }
}
