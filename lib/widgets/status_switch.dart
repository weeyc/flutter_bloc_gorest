import 'package:flutter/material.dart';

class StatusSwitch extends StatefulWidget {
  const StatusSwitch({Key? key, required this.statusController, this.isEditing = false}) : super(key: key);
  final TextEditingController statusController;
  final bool isEditing;
  @override
  State<StatusSwitch> createState() => _StatusSwitchState();
}

class _StatusSwitchState extends State<StatusSwitch> {
  bool active = true;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isEditing) {
        active = widget.statusController.text == 'active';
      } else {
        widget.statusController.text = 'active';
        active = true;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: active,
      activeColor: Colors.green,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          active = value;
          widget.statusController.text = active ? 'active' : 'inactive';
        });
      },
    );
  }
}
