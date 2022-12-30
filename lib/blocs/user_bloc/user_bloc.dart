import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_rest_bloc/models/user_model.dart';
import 'package:go_rest_bloc/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UsersState> {
  final UserRepository _userRepository;

  UserBloc(this._userRepository) : super(UsersInitialState()) {
    on<UsersFetchEvent>(_onUserFetchEvent);
    on<UsersSearchEvent>(_onUserSearchEvent);
    on<UserAddEvent>(_onUserAddEvent);
  }

  Future<void> _onUserFetchEvent(UsersFetchEvent event, Emitter<UsersState> emit) async {
    emit(UsersLoadingState());
    try {
      final List<UserModel> users = await _userRepository.getUsers();
      emit(UsersLoadedState(users: users));
    } catch (e) {
      emit(UsersErrorState(message: e.toString()));
    }
  }

  Future<void> _onUserSearchEvent(UsersSearchEvent event, Emitter<UsersState> emit) async {
    emit(UsersLoadingState());
    try {
      List<UserModel> usersList = [];
      await _userRepository.getSpecificUser(event.id).then((UserModel user) {
        if (user.id != null) {
          usersList.add(user);
          emit(UsersLoadedState(users: usersList));
        } else {
          usersList = [];
          emit(UsersSearchedEmptyState(users: usersList));
        }
      });
    } catch (e) {
      emit(UsersErrorState(message: e.toString()));
    }
  }

  Future<void> _onUserAddEvent(UserAddEvent event, Emitter<UsersState> emit) async {
    emit(UsersLoadingState());
    try {
      await _userRepository.createUser(event.userModel).then((UserModel userModel) async {
        if (userModel.id != null) {
          emit(UserCreatedState(userModel: userModel));
          await _onUserFetchEvent(UsersFetchEvent(), emit);
        } else {
          emit(const UsersErrorState(message: 'Error adding user'));
        }
      });
    } catch (e) {
      emit(UsersErrorState(message: e.toString()));
    }
  }
}
