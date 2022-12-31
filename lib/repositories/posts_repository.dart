import 'dart:convert';

import 'package:go_rest_bloc/models/post_model.dart';
import 'package:go_rest_bloc/models/user_model.dart';
import 'package:go_rest_bloc/utils/constants.dart';
import 'package:go_rest_bloc/utils/log_utils.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class PostRepository {
  final String baseURL = MyConstants.baseURL;
  final String token = MyConstants.token;

  // get list of posts
  Future<List<PostModel>> getPosts() async {
    final response = await http.get(Uri.parse("$baseURL/posts"));
    LogUtil.verbose('GET POSTS API ${response.statusCode}');
    if (response.statusCode == 200) {
      final Iterable data = jsonDecode(response.body);
      final List<PostModel> posts = [];
      for (var user in data) {
        posts.add(PostModel.fromJson(user));
      }
      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // get user post post
  Future<List<PostModel>> getUserPosts(int userId) async {
    final response = await http.get(
      Uri.parse("$baseURL/users/$userId/posts"),
      headers: MyConstants.headers,
    );
    LogUtil.verbose('GET SPECIFIC USER POSTS API : ${response.statusCode}');
    if (response.statusCode == 200) {
      final Iterable data = jsonDecode(response.body);
      final List<PostModel> posts = [];
      for (var user in data) {
        posts.add(PostModel.fromJson(user));
      }
      return posts;
    } else {
      throw Exception('Failed to load user');
    }
  }

  // create user
  Future<PostModel> createUserPost(PostModel postModel) async {
    try {
      final Response response = await http.post(
        Uri.parse("$baseURL/users/${postModel.userId.toString()}/posts"),
        headers: MyConstants.headers,
        body: {"user_id": postModel.userId.toString(), "title": postModel.title, "body": postModel.body},
      );
      LogUtil.verbose('CREATE USER API : ${response.statusCode}');
      if (response.statusCode == 201) {
        return postModelFromJson(response.body);
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      LogUtil.error(e);
    }
    return postModel;
  }

  // post comments
  Future<void> getPostComments(PostModel postModel, UserModel userModel) async {
    final response = await http.get(
      Uri.parse("$baseURL/posts/${postModel.id}/comments"),
      headers: MyConstants.headers,
    );
    LogUtil.verbose('CREATE USER API : ${response.statusCode}');
    if (response.statusCode == 201) {
      print('User created');
    } else {
      throw Exception('Failed to create post comment');
    }
  }
}
