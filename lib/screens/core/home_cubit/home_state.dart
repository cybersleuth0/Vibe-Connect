import "package:cloud_firestore/cloud_firestore.dart";

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> chatrooms;

  HomeLoaded({required this.chatrooms});
}

class HomeError extends HomeState {
  final String error;

  HomeError({required this.error});
}
