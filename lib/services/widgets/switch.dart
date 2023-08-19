import 'package:flutter/material.dart';

import 'extension.dart';

class MySwitch extends StatelessWidget {
  final String title;
  final bool value;
  final Alignment alignment;
  final Function(bool)? onChange;
  const MySwitch(
      {Key? key,
      required this.title,
      required this.onChange,
      required this.value,
      required this.alignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Row(
        children: [
          Text(title).hPadding9,
          Switch(value: value, onChanged: onChange),
        ],
      ),
    ).padding9;
  }
}
