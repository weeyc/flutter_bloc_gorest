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
