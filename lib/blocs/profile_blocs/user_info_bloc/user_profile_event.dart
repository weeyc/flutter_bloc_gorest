part of 'user_profile_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();
}

class UserProfileFetchEvent extends UserProfileEvent {
  const UserProfileFetchEvent(this.userModel);
  final UserModel userModel;
  @override
  List<Object> get props => [userModel];
}

class EditUserProfileEvent extends UserProfileEvent {
  const EditUserProfileEvent(this.userModel);
  final UserModel userModel;
  @override
  List<Object> get props => [userModel];
}

class DeleteUserProfileEvent extends UserProfileEvent {
  const DeleteUserProfileEvent(this.userModel);
  final UserModel userModel;
  @override
  List<Object> get props => [userModel];
}
