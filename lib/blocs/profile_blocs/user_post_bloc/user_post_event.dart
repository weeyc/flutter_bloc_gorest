part of 'user_post_bloc.dart';

abstract class UserPostEvent extends Equatable {
  const UserPostEvent();
}

class ProfilePostsFetchEvent extends UserPostEvent {
  const ProfilePostsFetchEvent(this.userModel);
  final UserModel userModel;
  @override
  List<Object> get props => [userModel];
}

class ProfileCreatePostEvent extends UserPostEvent {
  const ProfileCreatePostEvent(this.postModel);
  final PostModel postModel;
  @override
  List<Object> get props => [postModel];
}
