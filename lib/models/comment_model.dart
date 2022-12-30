// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

CommentModel commentModelFromJson(String str) => CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  CommentModel({
    this.id,
    this.postId,
    this.name,
    this.email,
    this.body,
  });

  int? id;
  int? postId;
  String? name;
  String? email;
  String? body;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"],
        postId: json["post_id"],
        name: json["name"],
        email: json["email"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "post_id": postId,
        "name": name,
        "email": email,
        "body": body,
      };
}
//17934
