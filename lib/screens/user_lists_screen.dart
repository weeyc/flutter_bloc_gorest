import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_rest_bloc/blocs/profile_blocs/user_info_bloc/user_profile_bloc.dart';
import 'package:go_rest_bloc/blocs/profile_blocs/user_post_bloc/user_post_bloc.dart';
import 'package:go_rest_bloc/blocs/profile_blocs/user_todo_bloc/user_todo_bloc.dart';
import 'package:go_rest_bloc/blocs/user_bloc/user_bloc.dart';
import 'package:go_rest_bloc/models/user_model.dart';
import 'package:go_rest_bloc/repositories/posts_repository.dart';
import 'package:go_rest_bloc/repositories/todos_repository.dart';
import 'package:go_rest_bloc/repositories/user_repository.dart';
import 'package:go_rest_bloc/screens/user_profile.dart';
import 'package:go_rest_bloc/utils/log_utils.dart';
import 'package:go_rest_bloc/widgets/user_form.dart';
import 'package:go_rest_bloc/widgets/user_tiles.dart';

class UserListScreen extends StatelessWidget {
  UserListScreen({Key? key}) : super(key: key);
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('User List')),
        body: BlocListener<UserBloc, UsersState>(
          bloc: userBloc,
          listener: (context, state) {
            if (state is UsersErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Something Went Wrong!'), backgroundColor: Colors.red),
              );
            } else if (state is UserCreatedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('UserId: ${state.userModel.id} Created Successfully'), backgroundColor: Colors.green, duration: const Duration(seconds: 10)),
              );
            }
          },
          child: RefreshIndicator(
            onRefresh: () async {
              userBloc.add(UsersFetchEvent());
            },
            child: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                Material(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search user Id',
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                        suffix: searchController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  searchController.clear();
                                  userBloc.add(UsersFetchEvent());
                                },
                                child: const Icon(Icons.clear),
                              )
                            : null,
                      ),
                      controller: searchController,
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          final int? userId = int.tryParse(value);
                          userBloc.add(UsersSearchEvent(userId ?? 1));
                        }
                      },
                    ),
                  ),
                ),
                BlocBuilder<UserBloc, UsersState>(
                  builder: (userBlocContext, state) {
                    if (state is UsersInitialState) {
                      return const Center(child: Text('Empty'));
                    } else if (state is UsersLoadingState) {
                      return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 20),
                        child: const CircularProgressIndicator(),
                      );
                    } else if (state is UsersLoadedState) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.users.length,
                        itemBuilder: (listViewContext, index) {
                          return UserTile(
                            name: state.users[index].name ?? '',
                            email: state.users[index].email ?? '',
                            id: state.users[index].id ?? 0,
                            gender: state.users[index].gender ?? '',
                            status: state.users[index].status ?? '',
                            onTap: () {
                              Navigator.of(listViewContext).push(
                                MaterialPageRoute(
                                    builder: (materialContext) => MultiRepositoryProvider(
                                          providers: [
                                            RepositoryProvider<UserRepository>(
                                              create: (context) => UserRepository(),
                                            ),
                                            RepositoryProvider<PostRepository>(
                                              create: (context) => PostRepository(),
                                            ),
                                            RepositoryProvider<ToDoRepository>(
                                              create: (context) => ToDoRepository(),
                                            ),
                                          ],
                                          child: MultiBlocProvider(
                                            providers: [
                                              // Firstly created User Profile Bloc Provider
                                              BlocProvider(create: (userProfileContext) {
                                                return UserProfileBloc(userProfileContext.read<UserRepository>())..add(UserProfileFetchEvent(state.users[index]));
                                              }),

                                              BlocProvider(create: (profilePostContext) {
                                                return UserPostBloc(profilePostContext.read<PostRepository>())..add(ProfilePostsFetchEvent(state.users[index]));
                                              }),

                                              BlocProvider(create: (todoProfileContext) {
                                                return UserTodoBloc(todoProfileContext.read<ToDoRepository>())..add(ProfileTodoFetchEvent(state.users[index]));
                                              }),

                                              // Reuse User Bloc Provider of User List Screen Context
                                              BlocProvider.value(value: BlocProvider.of<UserBloc>(context)),
                                            ],
                                            child: UserProfile(userModel: state.users[index]),
                                          ),
                                        )),
                              );
                            },
                          );
                        },
                      );
                    } else if (state is UsersSearchedEmptyState) {
                      return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 40),
                        child: const Text('USER NOT FOUND'),
                      );
                    } else if (state is UsersErrorState) {
                      return Center(child: Text(state.message));
                    } else {
                      return const Center(
                        child: Text('Something went wrong!'),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _createDialog(context, userBloc);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _createDialog(BuildContext context, UserBloc userBloc) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController genderController = TextEditingController();
    final TextEditingController statusController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return UserForm(
          formKey: _formKey,
          isEditing: false,
          emailController: emailController,
          nameController: nameController,
          formLabel: 'Create User',
          genderController: genderController,
          statusController: statusController,
          onPressed: () {
            UserModel userModel = UserModel(
              name: nameController.text,
              gender: genderController.text,
              email: emailController.text,
              status: statusController.text,
            );
            //validate form
            if (_formKey.currentState!.validate()) {
              LogUtil.verbose(userModel.toJson());
              userBloc.add(UserAddEvent(userModel));
              Navigator.of(context).pop();
            }
          },
        );
      },
    );
  }
}
