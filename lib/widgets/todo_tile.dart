import 'package:flutter/material.dart';

class ToDoTile extends StatelessWidget {
  const ToDoTile({
    Key? key,
    required this.id,
    required this.title,
    required this.time,
    this.isDone = false,
  }) : super(key: key);

  final String id;
  final String title;
  final String time;
  final bool isDone;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.deepPurple[200],
      leading: Text(id),
      title: Text(title),
      subtitle: Text(time),
      trailing: isDone ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.check_circle_outline, color: Colors.red),
    );
  }
}
