part of 'user_post_bloc.dart';

abstract class UserPostState extends Equatable {
  const UserPostState();
}

class UserPostInitial extends UserPostState {
  @override
  List<Object> get props => [];
}

// POST
class ProfilePostLoadingState extends UserPostState {
  @override
  List<Object> get props => [];
}

class ProfilePostCreatedState extends UserPostState {
  const ProfilePostCreatedState(this.post);
  final PostModel post;
  @override
  List<Object> get props => [post];
}

class ProfilePostLoadedState extends UserPostState {
  const ProfilePostLoadedState(this.posts);
  final List<PostModel> posts;
  @override
  List<Object> get props => [posts];
}

class ProfilePostEmptyState extends UserPostState {
  @override
  List<Object> get props => [];
}

class ProfilePostErrorState extends UserPostState {
  const ProfilePostErrorState(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
