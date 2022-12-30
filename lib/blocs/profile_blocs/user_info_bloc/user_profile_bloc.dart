import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_rest_bloc/models/user_model.dart';
import 'package:go_rest_bloc/repositories/user_repository.dart';
import 'package:go_rest_bloc/utils/log_utils.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserRepository _userRepository;

  UserProfileBloc(this._userRepository) : super(UserProfileInitialState(UserModel())) {
    on<UserProfileFetchEvent>(_onUserProfileFetchEvent);
    on<EditUserProfileEvent>(_onEditUserProfileEvent);
    on<DeleteUserProfileEvent>(_onDeleteUserProfileEvent);
  }

  Future<void> _onUserProfileFetchEvent(UserProfileFetchEvent event, Emitter<UserProfileState> emit) async {
    emit(UserProfileInitialState(event.userModel));
    try {
      final UserModel users = await _userRepository.getSpecificUser(event.userModel.id ?? 0);
      emit(UserProfileLoadedState(users));
    } catch (e) {
      emit(UserProfileErrorState(e.toString()));
    }
  }

  Future<void> _onEditUserProfileEvent(EditUserProfileEvent event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoadingState());
    try {
      await _userRepository.updateUser(event.userModel).then((value) async {
        LogUtil.verbose(event.userModel.id);
        if (value) {
          UserModel users = await _userRepository.getSpecificUser(event.userModel.id ?? 0);
          emit(UserProfileEditedState());
          emit(UserProfileLoadedState(users));
        } else {
          emit(const UserProfileErrorState('Error updating user'));
        }
      });
    } catch (e) {
      LogUtil.verbose(e.toString());
      emit(UserProfileErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteUserProfileEvent(DeleteUserProfileEvent event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoadingState());
    try {
      await _userRepository.deleteUser(event.userModel.id ?? 0).then((value) async {
        if (value) {
          emit(const UserProfileDeletedState('User deleted'));
        } else {
          emit(const UserProfileErrorState('Error deleting user'));
        }
      });
    } catch (e) {
      emit(UserProfileErrorState(e.toString()));
    }
  }
}
