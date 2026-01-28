import "package:chat_app/data/remote/repository/firebase_repository.dart";
import "package:chat_app/screens/auth/profile_setup_cubit/profile_setup_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  final FirebaseRepository firebaseRepository;

  ProfileSetupCubit({required this.firebaseRepository}) : super(ProfileSetupInitial());

  Future<void> updateProfile({required String userId, required String name, required String phone}) async {
    emit(ProfileSetupLoading());
    try {
      final Map<String, dynamic> data = {
        "name": name,
        "mobNo": phone,
        "isOnline": true,
        "accountStatus": 1, // Ensure account is active
        "profileStatus": 1, // Public by default
      };

      await firebaseRepository.updateUserData(data, userId);
      emit(ProfileSetupSuccess());
    } catch (e) {
      emit(ProfileSetupFailure(error: e.toString()));
    }
  }
}
