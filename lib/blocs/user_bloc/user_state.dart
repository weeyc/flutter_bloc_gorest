part of 'user_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();
}

class UsersInitialState extends UsersState {
  @override
  List<Object> get props => [];
}

class UsersLoadingState extends UsersState {
  @override
  List<Object> get props => [];
}

class UsersLoadedState extends UsersState {
  final List<UserModel> users;
  const UsersLoadedState({required this.users});

  @override
  List<Object> get props => [users];
}

class UsersSearchedEmptyState extends UsersState {
  final List<UserModel> users;
  const UsersSearchedEmptyState({required this.users});

  @override
  List<Object> get props => [users];
}

class UserCreatedState extends UsersState {
  final UserModel userModel;
  const UserCreatedState({required this.userModel});
  @override
  List<Object> get props => [userModel];
}

class UsersErrorState extends UsersState {
  final String message;
  const UsersErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
