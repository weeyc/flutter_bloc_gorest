import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_rest_bloc/models/post_model.dart';
import 'package:go_rest_bloc/models/user_model.dart';
import 'package:go_rest_bloc/repositories/posts_repository.dart';

part 'user_post_event.dart';
part 'user_post_state.dart';

class UserPostBloc extends Bloc<UserPostEvent, UserPostState> {
  final PostRepository _postRepository;
  UserPostBloc(this._postRepository) : super(UserPostInitial()) {
    on<ProfilePostsFetchEvent>(_onProfilePostsFetchEvent);
    on<ProfileCreatePostEvent>(_onProfileCreatePostEvent);
  }

  Future<void> _onProfilePostsFetchEvent(ProfilePostsFetchEvent event, Emitter<UserPostState> emit) async {
    emit(ProfilePostLoadingState());
    try {
      await _postRepository.getUserPosts(event.userModel.id ?? 0).then((List<PostModel> posts) {
        if (posts.isNotEmpty) {
          emit(ProfilePostLoadedState(posts));
        } else {
          emit(ProfilePostEmptyState());
        }
      });
    } catch (e) {
      emit(ProfilePostErrorState(e.toString()));
    }
  }

  Future<void> _onProfileCreatePostEvent(ProfileCreatePostEvent event, Emitter<UserPostState> emit) async {
    emit(ProfilePostLoadingState());
    try {
      await _postRepository.createUserPost(event.postModel).then((PostModel postCreated) async {
        if (postCreated.id != null) {
          emit(ProfilePostCreatedState(postCreated));
          await _onProfilePostsFetchEvent(ProfilePostsFetchEvent(UserModel(id: event.postModel.userId)), emit);
        } else {
          emit(const ProfilePostErrorState('Failed to create post'));
        }
      });
    } catch (e) {
      emit(ProfilePostErrorState(e.toString()));
    }
  }
}
