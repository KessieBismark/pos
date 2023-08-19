import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../responsive.dart';
import '../services/menu_controller/menu_controller.dart';
import 'drawer/drawer.dart';

class Framework extends StatelessWidget {
  final Widget panel;
  final String? selected;
  final String? name;
  const Framework({Key? key, required this.panel, this.selected,  this.name, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MyMenuController>().scaffoldKey,
      drawer: MyDrawer(
        selectedItem: selected,
        name:name,
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: MyDrawer(
                  selectedItem: selected,
                ),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: panel,
            ),
          ],
        ),
      ),
    );
  }
}
