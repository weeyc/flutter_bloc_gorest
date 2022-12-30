import 'package:flutter/material.dart';
import 'package:go_rest_bloc/blocs/user_bloc/user_bloc.dart';
import 'package:go_rest_bloc/repositories/user_repository.dart';
import 'package:go_rest_bloc/screens/user_lists_screen.dart';
import 'package:go_rest_bloc/screens/user_profile.dart';

class RoutesName {
  static const String userLists = '/';
  static const String userProfile = '/userProfile';
}

class AppRoutes {
  final UserBloc _userBloc = UserBloc(UserRepository());

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.userLists:
        return MaterialPageRoute(builder: (_) => UserListScreen());
      // case RoutesName.userProfile:
      //   return MaterialPageRoute(builder: (_) => const UserProfile());
      default:
        return MaterialPageRoute(builder: (_) => UserListScreen());
    }
  }
}
