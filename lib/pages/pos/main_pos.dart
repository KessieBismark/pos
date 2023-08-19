import 'package:flutter/material.dart';

import '../../responsive.dart';
import 'mob_pos.dart';
import 'pos.dart';


class MainPOS extends StatelessWidget {
  const MainPOS({super.key});

  @override
  Widget build(BuildContext context) {
    return
         (Responsive.isDesktop(context) || Responsive.isTablet(context))
            ?
        const POS()
    : const MobPOS();
  }
}
