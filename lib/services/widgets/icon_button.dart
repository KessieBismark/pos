import 'package:flutter/material.dart';

class MIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  const MIconButton({Key? key, required this.onPressed, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: icon);
  }
}
