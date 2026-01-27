import "package:chat_app/data/models/user_model.dart";
import "package:chat_app/screens/auth/sign_up_cubit/sign_up_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../data/remote/repository/firebase_repository.dart";

class RegisterCubit extends Cubit<RegisterState> {
  FirebaseRepository firebaseRepository;

  RegisterCubit({required this.firebaseRepository}) : super(RegisterInitialState());

  Future<void> registerUser(UserModel user, String passwd) async {
    emit(RegisterLoadingState());
    try {
      final bool success = await firebaseRepository.registerUser(user: user, password: passwd);
      if (success) {
        emit(RegisterSuccessState());
      } else {
        emit(RegisterFailureState(error: "Registration failed"));
      }
    } catch (e) {
      emit(RegisterFailureState(error: e.toString()));
    }
  }
}
