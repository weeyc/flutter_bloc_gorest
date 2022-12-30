import 'dart:convert';

import 'package:go_rest_bloc/models/user_model.dart';
import 'package:go_rest_bloc/utils/constants.dart';
import 'package:go_rest_bloc/utils/log_utils.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final String baseURL = MyConstants.baseURL;
  final String token = MyConstants.token;

  // get list of users
  Future<List<UserModel>> getUsers() async {
    final response = await http.get(Uri.parse("$baseURL/users"));
    LogUtil.verbose('GET USERS API ${response.statusCode}');
    if (response.statusCode == 200) {
      final Iterable data = jsonDecode(response.body);
      final List<UserModel> users = [];
      for (var user in data) {
        users.add(UserModel.fromJson(user));
      }
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<UserModel> getSpecificUser(int id) async {
    final response = await http.get(
      Uri.parse("$baseURL/users/$id"),
      headers: MyConstants.headers,
    );
    LogUtil.verbose('GET SPECIFIC USER API : ${response.statusCode}');
    if (response.statusCode == 200) {
      return userModelFromJson(response.body);
    } else if (response.statusCode == 404) {
      return UserModel();
    } else {
      throw Exception('Failed to load user');
    }
  }

  // create user
  Future<UserModel> createUser(UserModel userModel) async {
    final response = await http.post(Uri.parse("$baseURL/users"), headers: MyConstants.headers, body: {
      "name": userModel.name,
      "gender": userModel.gender,
      "email": userModel.email,
      "status": userModel.status,
    });
    LogUtil.verbose('CREATE USER API : ${response.statusCode}');
    if (response.statusCode == 201) {
      return userModelFromJson(response.body);
    } else {
      throw Exception('Failed to create user');
    }
  }

  // update user
  Future<bool> updateUser(UserModel userModel) async {
    final response = await http.patch(
      Uri.parse("$baseURL/users/${userModel.id}"),
      headers: MyConstants.headers,
      body: {
        "name": userModel.name,
        "gender": userModel.gender,
        "email": userModel.email,
        "status": userModel.status,
      },
    );
    LogUtil.verbose('UPDATE USER API : ${response.statusCode}');
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update user');
    }
  }

  // delete user
  Future<bool> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse("$baseURL/users/$id"),
      headers: MyConstants.headers,
    );
    LogUtil.verbose('DELETE USER API : ${response.statusCode}');
    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete user');
    }
  }
}
