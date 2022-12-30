import 'package:flutter/material.dart';
import 'package:go_rest_bloc/blocs/user_bloc/user_bloc.dart';
import 'package:go_rest_bloc/error.dart';
import 'package:go_rest_bloc/repositories/user_repository.dart';
import 'package:go_rest_bloc/screens/user_lists_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorHandler.catchAll(() {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'GO Rest API',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF0f2537),
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF20374c)),
          // primaryColor: const Color(0xFF20374c),
          // accentColor: const Color(0xFF0f2537),
          textTheme: const TextTheme(
            headline1: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            bodyText1: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            bodyText2: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        home: RepositoryProvider(
          create: (context) => UserRepository(),
          child: BlocProvider(
            create: (context) => UserBloc(context.read<UserRepository>())..add(UsersFetchEvent()),
            child: UserListScreen(),
          ),
        ));
  }
}
