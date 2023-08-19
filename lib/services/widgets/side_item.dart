
import 'package:flutter/material.dart';

import '../constants/color.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile(
      {Key? key,
      // For selecting those three line once press "Command+D"
      required this.title,
      required this.icon,
      required this.press,
      this.active = false})
      : super(key: key);

  final String title;
  final VoidCallback press;
  final Icon icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      selected: active,
      selectedTileColor: active ? secondaryLight : trans,
      leading: icon,
      title: Text(
        title,
        style: TextStyle(color: dark),
      ),
    );
  }
}
