import 'package:flutter/material.dart';

class PostTiles extends StatelessWidget {
  const PostTiles({Key? key, required this.id, required this.title, required this.body}) : super(key: key);
  final String id;
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.blue[200],
      leading: Text(id),
      title: Text(title),
      subtitle: Text(body),
      onTap: () {},
    );
  }
}
