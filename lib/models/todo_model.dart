// To parse this JSON data, do
//
//     final toDoModel = toDoModelFromJson(jsonString);

import 'dart:convert';

ToDoModel toDoModelFromJson(String str) => ToDoModel.fromJson(json.decode(str));

String toDoModelToJson(ToDoModel data) => json.encode(data.toJson());

class ToDoModel {
  ToDoModel({
    this.id,
    this.userId,
    this.title,
    this.dueOn,
    this.status,
  });

  int? id;
  int? userId;
  String? title;
  String? dueOn;
  String? status;

  factory ToDoModel.fromJson(Map<String, dynamic> json) => ToDoModel(
        id: json["id"],
        userId: json["user_id"],
        title: json["title"],
        dueOn: json["due_on"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "due_on": dueOn,
        "status": status,
      };
}
