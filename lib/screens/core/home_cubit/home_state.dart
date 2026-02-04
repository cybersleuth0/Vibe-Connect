import "package:vibe_connect/data/models/chatroom_model.dart";
import "package:vibe_connect/data/models/user_model.dart";

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ChatRoomWithUser> chatRooms;
  HomeLoaded({required this.chatRooms});
}

class HomeError extends HomeState {
  final String error;
  HomeError({required this.error});
}

class ChatRoomWithUser {
  final ChatRoomModel chatRoom;
  final UserModel user;

  ChatRoomWithUser({required this.chatRoom, required this.user});
}