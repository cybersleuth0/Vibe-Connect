import "package:vibe_connect/data/remote/repository/firebase_repository.dart";
import "package:vibe_connect/screens/auth/login_cubit/login_state.dart";
import "package:vibe_connect/utils/auth_exception_handler.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class LoginCubit extends Cubit<LoginState> {
  final FirebaseRepository firebaseRepository;

  LoginCubit({required this.firebaseRepository}) : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      await firebaseRepository.loginUser(email: email, password: password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(error: AuthExceptionHandler.handleException(e)));
    }
  }

  Future<void> logout() async {
    emit(LoginLoading());
    try {
      await firebaseRepository.logoutUser();
      emit(LoginInitial());
    } catch (e) {
      emit(LoginFailure(error: AuthExceptionHandler.handleException(e)));
    }
  }
}
