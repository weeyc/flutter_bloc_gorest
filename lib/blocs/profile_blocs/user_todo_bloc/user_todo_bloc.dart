import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_rest_bloc/models/todo_model.dart';
import 'package:go_rest_bloc/models/user_model.dart';
import 'package:go_rest_bloc/repositories/todos_repository.dart';

part 'user_todo_event.dart';
part 'user_todo_state.dart';

class UserTodoBloc extends Bloc<UserTodoEvent, UserTodoState> {
  final ToDoRepository _todoRepository;
  UserTodoBloc(this._todoRepository) : super(UserTodoInitial()) {
    on<ProfileTodoFetchEvent>(_onProfileTodoFetchEvent);
  }

  Future<void> _onProfileTodoFetchEvent(ProfileTodoFetchEvent event, Emitter<UserTodoState> emit) async {
    emit(ProfileTodoLoadingState());
    try {
      await _todoRepository.getUserTodos(event.userModel.id ?? 0).then((List<ToDoModel> todos) {
        if (todos.isNotEmpty) {
          emit(ProfileTodoLoadedState(todos));
        } else {
          emit(ProfileTodoEmptyState());
        }
      });
    } catch (e) {
      emit(ProfileTodoErrorState(e.toString()));
    }
  }
}
