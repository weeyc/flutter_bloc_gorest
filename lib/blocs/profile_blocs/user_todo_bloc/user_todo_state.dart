part of 'user_todo_bloc.dart';

abstract class UserTodoState extends Equatable {
  const UserTodoState();
}

class UserTodoInitial extends UserTodoState {
  @override
  List<Object> get props => [];
}

class ProfileTodoLoadingState extends UserTodoState {
  @override
  List<Object> get props => [];
}

class ProfileTodoLoadedState extends UserTodoState {
  const ProfileTodoLoadedState(this.todos);
  final List<ToDoModel> todos;
  @override
  List<Object> get props => [todos];
}

class ProfileTodoEmptyState extends UserTodoState {
  @override
  List<Object> get props => [];
}

class ProfileTodoErrorState extends UserTodoState {
  const ProfileTodoErrorState(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
