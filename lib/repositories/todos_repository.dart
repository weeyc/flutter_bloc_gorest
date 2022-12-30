import 'dart:convert';
import 'package:go_rest_bloc/models/todo_model.dart';
import 'package:go_rest_bloc/models/user_model.dart';
import 'package:go_rest_bloc/utils/constants.dart';
import 'package:go_rest_bloc/utils/log_utils.dart';
import 'package:http/http.dart' as http;

class ToDoRepository {
  final String baseURL = MyConstants.baseURL;
  final String token = MyConstants.token;

  // get list of posts
  Future<List<ToDoModel>> getToDoLists() async {
    final response = await http.get(Uri.parse("$baseURL/todos"));
    LogUtil.verbose('GET TODOS API ${response.statusCode}');
    if (response.statusCode == 200) {
      final Iterable data = jsonDecode(response.body);
      final List<ToDoModel> todos = [];
      for (var todo in data) {
        todos.add(ToDoModel.fromJson(todo));
      }
      return todos;
    } else {
      throw Exception('Failed to load todos');
    }
  }

  // get user post post
  Future<List<ToDoModel>> getUserTodos(int userId) async {
    final response = await http.get(
      Uri.parse("$baseURL/users/$userId/todos"),
      headers: MyConstants.headers,
    );
    LogUtil.verbose('GET SPECIFIC USER POSTS API : ${response.statusCode}');
    if (response.statusCode == 200) {
      final Iterable data = jsonDecode(response.body);
      final List<ToDoModel> todos = [];
      for (var todo in data) {
        todos.add(ToDoModel.fromJson(todo));
      }
      return todos;
    } else {
      throw Exception('Failed to load todo');
    }
  }
}
