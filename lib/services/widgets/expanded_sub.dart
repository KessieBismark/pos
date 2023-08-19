import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:get/get.dart';

import 'extension.dart';

class SubItem extends StatelessWidget {
  final String title;
  final String? selected;
  const SubItem({
    Key? key,
    required this.title,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List list = title.split("-");
    return ListTile(
      title: Row(
        // mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Icon(Entypo.dot),
          Text(list[0].toString().capitalize!,
              style: const TextStyle(
                  overflow: TextOverflow.ellipsis, fontSize: 15))
        ],
      ).hPadding6,
      // selected: list[1] == selected ? true : false,
      onTap: () => Get.offNamed(list[1]),
    );
  }
}
