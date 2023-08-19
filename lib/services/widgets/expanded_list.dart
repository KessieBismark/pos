import 'package:flutter/material.dart';

import '../constants/color.dart';
import 'expanded_sub.dart';
import 'extension.dart';

class ExpandItems extends StatelessWidget {
  final IconData leading;
  final String title;
  final List subMenus;
  final String? name;
  final String? selectedItem;

  const ExpandItems(
      {Key? key,
      required this.leading,
      required this.title,
      required this.subMenus,
      this.selectedItem,
       this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.all(0),
      title: subMenus.contains('$name-$selectedItem')
          ? title.toLabel(color: activeTab,fontsize: 16)
          : title.toLabel(fontsize: 15),
      leading: subMenus.contains('$name-$selectedItem')
          ? Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Icon(leading, color: activeTab),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Icon(leading),
            ),
      children: [
        for (int i = 0; i < subMenus.length; i++)
          SubItem(title: subMenus[i], selected: selectedItem)
      ],
    );
  }
}
