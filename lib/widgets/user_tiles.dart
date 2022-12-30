import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    Key? key,
    required this.name,
    required this.email,
    required this.id,
    required this.gender,
    required this.status,
    this.onTap,
  }) : super(key: key);

  final String name;
  final String email;
  final int id;
  final String gender;
  final String status;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    IconData genderIcon = Icons.male;
    Color genderIconColor = Colors.blue[900]!;
    Color colorStatus = Colors.green[500]!;

    if (gender == 'male') {
      genderIcon = Icons.male;
      genderIconColor = Colors.blue[900]!;
    } else {
      genderIcon = Icons.female;
      genderIconColor = Colors.pink[900]!;
    }
    if (status == 'active') {
      colorStatus = Colors.green[500]!;
    } else {
      colorStatus = Colors.red[500]!;
    }

    return ListTile(
      tileColor: Colors.blueGrey,
      onTap: onTap,
      contentPadding: const EdgeInsets.all(8),
      title: Text(name),
      subtitle: Text(email),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [const Icon(Icons.numbers), Text(id.toString(), style: const TextStyle(color: Colors.black54))],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(genderIcon, color: genderIconColor),
          const SizedBox(width: 5),
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: colorStatus,
              shape: BoxShape.circle,
            ),
          )
        ],
      ),
    );
  }
}
