import 'package:flutter/material.dart';
import 'package:go_rest_bloc/widgets/gender_radio_button.dart';
import 'package:go_rest_bloc/widgets/status_switch.dart';

class UserForm extends StatelessWidget {
  const UserForm({
    Key? key,
    required this.nameController,
    required this.emailController,
    required this.genderController,
    required this.statusController,
    this.onPressed,
    required this.formLabel,
    this.isEditing = false,
    required this.formKey,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController genderController;
  final TextEditingController statusController;
  final void Function()? onPressed;
  final String formLabel;
  final bool isEditing;
  final Key formKey;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
          children: [
            Text(formLabel, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Name'),
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty || value.trim().isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Email'),
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty || value.trim().isEmpty) {
                  return 'Please enter email';
                } else if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(value)) {
                  return 'Please enter valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Sex'),
              controller: genderController,
              readOnly: true,
            ),
            GenderRadioButton(genderController: genderController, isEditing: isEditing),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Status'),
              controller: statusController,
              readOnly: true,
            ),
            StatusSwitch(statusController: statusController, isEditing: isEditing),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                const SizedBox(width: 10),
                TextButton(onPressed: onPressed, child: const Text('Save')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
