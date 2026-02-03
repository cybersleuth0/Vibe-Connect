import "package:vibe_connect/data/models/user_model.dart";
import "package:vibe_connect/screens/auth/sign_up_cubit/sign_up_state.dart";
import "package:vibe_connect/utils/auth_exception_handler.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../data/remote/repository/firebase_repository.dart";

class RegisterCubit extends Cubit<RegisterState> {
  FirebaseRepository firebaseRepository;

  RegisterCubit({required this.firebaseRepository}) : super(RegisterInitialState());

  Future<void> registerUser(UserModel user, String passwd) async {
    print("Registering user: ${user.email} $passwd");
    emit(RegisterLoadingState());
    try {
      final bool success = await firebaseRepository.registerUser(user: user, password: passwd);
      if (success) {
        emit(RegisterSuccessState());
      } else {
        emit(RegisterFailureState(error: "Registration failed"));
      }
    } catch (e) {
      emit(RegisterFailureState(error: AuthExceptionHandler.handleException(e)));
    }
  }
}
