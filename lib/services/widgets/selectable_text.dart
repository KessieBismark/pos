import 'package:flutter/material.dart';

class SelectLabel extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color? color;
  final bool bold;
  const SelectLabel(
    this.title, {
    this.fontSize,
    this.color,
    this.bold = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      title,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal),
    );
  }
}
