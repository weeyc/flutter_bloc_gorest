import 'package:flutter/material.dart';

class PostForm extends StatelessWidget {
  const PostForm({
    Key? key,
    required this.formLabel,
    required this.titleController,
    required this.bodyController,
    this.onPressed,
    required this.formKey,
  }) : super(key: key);

  final String formLabel;
  final TextEditingController titleController;
  final TextEditingController bodyController;
  final void Function()? onPressed;
  final GlobalKey<FormState> formKey;
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
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Title'),
              controller: titleController,
              validator: (value) {
                if (value == null || value.isEmpty || value.trim().isEmpty) {
                  return 'Please enter title';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Body'),
              controller: bodyController,
              validator: (value) {
                if (value == null || value.isEmpty || value.trim().isEmpty) {
                  return 'Please enter body';
                }
                return null;
              },
            ),
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
