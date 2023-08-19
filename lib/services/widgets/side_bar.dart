
import 'package:flutter/material.dart';

import 'extension.dart';

class MSideBarItem extends StatelessWidget {
  final String title;
  final int value;
  final VoidCallback onPressed;
  final IconData icon;
  final bool selected;
  const MSideBarItem({
    required this.title,
    required this.onPressed,
    required this.icon,
    this.value = 0,
    this.selected = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      selectedTileColor: Colors.red,
      onTap: onPressed,
      title: title.toLabel(color: Colors.grey.shade800, fontsize: 16),
      leading: Icon(
        icon,
        color: Colors.grey.shade500,
        size: 16,
      ),
      trailing: value > 0
          ? CircleAvatar(
              backgroundColor: Colors.red[300],
              radius: 10,
              child: value.toString().toLabel(
                    fontsize: 10,
                  ),
            )
          : null,
    );
  }
}
