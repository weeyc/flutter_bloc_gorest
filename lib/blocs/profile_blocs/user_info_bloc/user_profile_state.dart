part of 'user_profile_bloc.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();
}

// USER INFORMATION
class UserProfileInitialState extends UserProfileState {
  const UserProfileInitialState(this.userModel);
  final UserModel userModel;
  @override
  List<Object> get props => [userModel];
}

class UserProfileLoadingState extends UserProfileState {
  @override
  List<Object> get props => [];
}

class UserProfileLoadedState extends UserProfileState {
  const UserProfileLoadedState(this.userModel);
  final UserModel userModel;
  @override
  List<Object> get props => [userModel];
}

class UserProfileEditedState extends UserProfileState {
  @override
  List<Object> get props => [];
}

class UserProfileDeletedState extends UserProfileState {
  const UserProfileDeletedState(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}

class UserProfileErrorState extends UserProfileState {
  const UserProfileErrorState(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
