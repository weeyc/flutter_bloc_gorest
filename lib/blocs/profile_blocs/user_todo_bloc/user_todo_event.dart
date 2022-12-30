part of 'user_todo_bloc.dart';

abstract class UserTodoEvent extends Equatable {
  const UserTodoEvent();
}

class ProfileTodoFetchEvent extends UserTodoEvent {
  const ProfileTodoFetchEvent(this.userModel);
  final UserModel userModel;
  @override
  List<Object> get props => [userModel];
}
