abstract class ProfileSetupState {}

class ProfileSetupInitial extends ProfileSetupState {}

class ProfileSetupLoading extends ProfileSetupState {}

class ProfileSetupSuccess extends ProfileSetupState {}

class ProfileSetupFailure extends ProfileSetupState {
  final String error;

  ProfileSetupFailure({required this.error});
}
