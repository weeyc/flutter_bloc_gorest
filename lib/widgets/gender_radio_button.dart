import 'package:flutter/material.dart';

class GenderRadioButton extends StatefulWidget {
  const GenderRadioButton({
    Key? key,
    required this.genderController,
    this.isEditing = false,
  }) : super(key: key);

  final TextEditingController genderController;
  final bool isEditing;

  @override
  State<GenderRadioButton> createState() => _GenderRadioButtonState();
}

class _GenderRadioButtonState extends State<GenderRadioButton> {
  String gender = 'male';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isEditing) {
        gender = widget.genderController.text;
      } else {
        widget.genderController.text = gender;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: RadioListTile(
            title: const Text("Male"),
            value: "male",
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = value.toString();
                widget.genderController.text = value.toString();
              });
            },
          ),
        ),
        Expanded(
          child: RadioListTile(
            title: const Text("Female"),
            value: "female",
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = value.toString();
                widget.genderController.text = value.toString();
              });
            },
          ),
        ),
      ],
    );
  }
}
