part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class UsersFetchEvent extends UserEvent {
  @override
  List<Object> get props => [];
}

class UsersSearchEvent extends UserEvent {
  const UsersSearchEvent(this.id);
  final int id;
  @override
  List<Object> get props => [id];
}

class UserAddEvent extends UserEvent {
  const UserAddEvent(this.userModel);
  final UserModel userModel;
  @override
  List<Object> get props => [userModel];
}
