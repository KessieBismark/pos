import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trialing;
  final bool selected;
  final VoidCallback? onTap;
  final Color? selectedColor;
  const DrawerItem(
      {Key? key,
      this.leading,
      required this.title,
      this.subtitle,
      this.trialing,
      this.selected = false,
      this.selectedColor,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 0.0,
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trialing,
      selected: selected,
     // selectedColor: lightGrey,
      onTap:  onTap,
    );
  }
}
