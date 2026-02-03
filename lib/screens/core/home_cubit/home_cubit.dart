import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../data/remote/repository/firebase_repository.dart";
import "home_state.dart";

class HomeCubit extends Cubit<HomeState> {
  final FirebaseRepository firebaseRepository;

  HomeCubit({required this.firebaseRepository}) : super(HomeInitial());

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatroomsStream() {
    return firebaseRepository.getUserChatrooms();
  }
}
