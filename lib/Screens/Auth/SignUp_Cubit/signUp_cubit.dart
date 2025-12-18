import 'package:chat_app/Data/Models/userModel.dart';
import 'package:chat_app/Screens/Auth/SignUp_Cubit/signUp_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Data/Remote/Repository/Firebase_repository.dart';

class RegisterCubit extends Cubit<RegisterState> {
  FirebaseRepository firebaseRepository;

  RegisterCubit({required this.firebaseRepository}) : super(RegisterInitialState());

  Future<void> registerUser(UserModel user, String passwd) async {
    emit(RegisterLoadingState());
    try {
      bool success = await firebaseRepository.registerUser(user: user, password: passwd);
      if(success) {
        emit(RegisterSuccessState());
      } else {
        emit(RegisterFailureState(error: 'Registration failed'));
      }
    } catch (e) {
      emit(RegisterFailureState(error: e.toString()));
    }
  }
}
