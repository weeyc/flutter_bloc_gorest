import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_rest_bloc/blocs/profile_blocs/user_info_bloc/user_profile_bloc.dart';
import 'package:go_rest_bloc/blocs/profile_blocs/user_post_bloc/user_post_bloc.dart';
import 'package:go_rest_bloc/blocs/profile_blocs/user_todo_bloc/user_todo_bloc.dart';
import 'package:go_rest_bloc/blocs/user_bloc/user_bloc.dart';
import 'package:go_rest_bloc/models/user_model.dart';
import 'package:go_rest_bloc/utils/log_utils.dart';
import 'package:go_rest_bloc/widgets/card.dart';
import 'package:go_rest_bloc/widgets/post_tiles.dart';
import 'package:go_rest_bloc/widgets/todo_tile.dart';
import 'package:go_rest_bloc/widgets/user_form.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key, required this.userModel}) : super(key: key);
  final UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    UserProfileBloc userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    UserPostBloc userPostBloc = BlocProvider.of<UserPostBloc>(context);
    UserTodoBloc userTodoBloc = BlocProvider.of<UserTodoBloc>(context);
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: BlocListener<UserProfileBloc, UserProfileState>(
        bloc: userProfileBloc,
        listener: (userProfileContext, state) {
          // After User profile edited
          if (state is UserProfileEditedState) {
            // refresh users list from previous page
            userBloc.add(UsersFetchEvent());
            ScaffoldMessenger.of(userProfileContext).showSnackBar(
              const SnackBar(content: Text('User information edited successfully'), backgroundColor: Colors.green),
            );
          }
          // After User profile deleted
          else if (state is UserProfileDeletedState) {
            ScaffoldMessenger.of(userProfileContext).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            // refresh users list from previous page and pop current page
            userBloc.add(UsersFetchEvent());
            Navigator.of(context).pop();

            // After Error occurred
          } else if (state is UserProfileErrorState) {
            if (userModel?.id != null) {
              userProfileBloc.add(UserProfileFetchEvent(userModel!));
            }
            ScaffoldMessenger.of(userProfileContext).showSnackBar(
              const SnackBar(content: Text('Something Went Wrong!'), backgroundColor: Colors.red),
            );
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                const Text('USER INFORMATION'),
                const Spacer(),
                BlocBuilder<UserProfileBloc, UserProfileState>(
                  bloc: userProfileBloc,
                  builder: (context, state) {
                    if (state is UserProfileLoadedState) {
                      return Row(
                        children: [
                          IconButton(
                            onPressed: () => _editDialog(context, userProfileBloc, state.userModel),
                            icon: const Icon(Icons.edit, color: Colors.green),
                            splashRadius: 14,
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _deleteDialog(context, userProfileBloc, state.userModel),
                            icon: const Icon(Icons.delete, color: Colors.red),
                            splashRadius: 14,
                          ),
                        ],
                      );
                    } else {
                      return IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete, color: Colors.transparent),
                        splashRadius: 14,
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 5),
            BlocBuilder<UserProfileBloc, UserProfileState>(
              bloc: userProfileBloc,
              builder: (context, state) {
                if (state is UserProfileInitialState) {
                  return ProfileCard(userModel: state.userModel);
                } else if (state is UserProfileLoadedState) {
                  return ProfileCard(userModel: state.userModel);
                } else if (state is UserProfileLoadingState) {
                  return const ProfileCardLoading();
                } else if (state is UserProfileErrorState) {
                  return Container();
                } else {
                  LogUtil.verbose('UserProfile: Unknown state');
                  return Container();
                }
              },
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                const Text('USER POSTS'),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add, color: Colors.green),
                  splashRadius: 14,
                ),
              ],
            ),
            const SizedBox(height: 20),
            BlocBuilder<UserPostBloc, UserPostState>(
              bloc: userPostBloc,
              builder: (context, state) {
                if (state is ProfilePostLoadedState) {
                  return ListView.builder(
                    itemCount: state.posts.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return PostTiles(
                        id: state.posts[index].id.toString(),
                        title: state.posts[index].title ?? '',
                        body: state.posts[index].body ?? '',
                      );
                    },
                  );
                } else if (state is ProfilePostLoadingState) {
                  return const SizedBox(
                    height: 150,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is ProfilePostEmptyState) {
                  return const SizedBox(
                    height: 50,
                    child: Center(child: Text('This user has no post')),
                  );
                } else if (state is UserProfileErrorState) {
                  return Container();
                } else {
                  LogUtil.verbose('UserProfile: Unknown state');
                  return Container();
                }
              },
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                const Text('USER TODO LIST'),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add, color: Colors.green),
                  splashRadius: 14,
                ),
              ],
            ),
            const SizedBox(height: 20),
            BlocBuilder<UserTodoBloc, UserTodoState>(
              bloc: userTodoBloc,
              builder: (context, state) {
                if (state is ProfileTodoLoadedState) {
                  return ListView.builder(
                    itemCount: state.todos.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ToDoTile(
                        id: state.todos[index].id.toString(),
                        title: state.todos[index].title ?? '',
                        time: state.todos[index].dueOn ?? '',
                        isDone: state.todos[index].status == 'completed',
                      );
                    },
                  );
                } else if (state is ProfileTodoLoadingState) {
                  return const SizedBox(
                    height: 150,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is ProfileTodoEmptyState) {
                  return const SizedBox(
                    height: 50,
                    child: Center(child: Text('This user has no todos list')),
                  );
                } else if (state is ProfileTodoErrorState) {
                  return Container();
                } else {
                  LogUtil.verbose('UserProfile: Unknown state');
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // edit dialog
  void _editDialog(BuildContext context, UserProfileBloc userProfileBloc, UserModel userModel) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController genderController = TextEditingController();
    final TextEditingController statusController = TextEditingController();
    nameController.text = userModel.name ?? '';
    emailController.text = userModel.email ?? '';
    genderController.text = userModel.gender ?? '';
    statusController.text = userModel.status ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return UserForm(
          emailController: emailController,
          nameController: nameController,
          formLabel: 'Edit User',
          isEditing: true,
          genderController: genderController,
          statusController: statusController,
          onPressed: () {
            UserModel editedUser = UserModel(
              id: userModel.id,
              name: nameController.text,
              gender: genderController.text,
              email: emailController.text,
              status: statusController.text,
            );
            LogUtil.verbose(editedUser.toJson());

            userProfileBloc.add(EditUserProfileEvent(editedUser));
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  // delete dialog
  void _deleteDialog(BuildContext context, UserProfileBloc userProfileBloc, UserModel userModel) {
    showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: false,
      builder: (context) {
        return Material(
          child: SizedBox(
            height: 200,
            child: ListView(
              padding: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 16),
              children: [
                const Text('Delete User', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const Text('Are you sure you want to delete this user?', style: TextStyle(color: Colors.black, fontSize: 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                    const SizedBox(width: 10),
                    TextButton(
                        onPressed: () {
                          userProfileBloc.add(DeleteUserProfileEvent(userModel));
                          Navigator.of(context).pop();
                        },
                        child: const Text('Delete')),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key, required this.userModel}) : super(key: key);
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Id: ${userModel.id ?? ''}'),
          const SizedBox(height: 20),
          Text('Name: ${userModel.name ?? ''}'),
          const SizedBox(height: 20),
          Text('Email: ${userModel.email ?? ''}'),
          const SizedBox(height: 20),
          Text('Sex: ${userModel.gender ?? ''}'),
          const SizedBox(height: 20),
          Text('Status: ${userModel.status ?? ''}'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ProfileCardLoading extends StatelessWidget {
  const ProfileCardLoading({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
