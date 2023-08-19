

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../services/constants/constant.dart';
import '../../responsive.dart';
import '../../services/widgets/extension.dart';
import '../../services/widgets/keyboard_listener.dart';
import '../../widgets/header/header.dart';
import 'component/controller/controller.dart';
import 'component/widgets/customer_section.dart';
import 'component/widgets/sales_info.dart';
import 'component/widgets/sales_table.dart';
import 'component/widgets/service_section.dart';
import 'component/widgets/total_section.dart';

class POS extends GetView<POSCon> {
  const POS({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyBoardTap(
      focusNode: FocusNode(),
      onKey: (event) {
        final key = event.logicalKey;
        if (event is RawKeyDownEvent) {
          if (controller.keys.contains(key)) return;
          if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
            controller.addToCart();
          }
          controller.keys.add(key);
        } else {
          controller.keys.remove(key);
        }
      },
      child: Scaffold(
          body: SafeArea(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Header(
                  pageName: "POS Section",
                  searchBar: Container(),
                ),
                const SizedBox(height: defaultPadding),
                (Responsive.isDesktop(context) || Responsive.isTablet(context))
                    ? Column(
                        children: [
                          /// Top level with customer, sales info and service section
                          topLevel(context),
                          const SizedBox(
                            height: 10,
                          ),

                          /// lower level with table, totals  and query buttons
                          SizedBox(
                            height: myHeight(context, 1.5),
                            child: Column(
                              children: [
                                SalesTable(
                                  controller: controller,
                                ),
                                TotalSection(
                                  controller: controller,
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    : Center(
                            child: "Use desktop view mode for this section"
                                .toAutoLabel(bold: true))
                        .padding9,
              ],
            )),
      )),
    );
  }

  SizedBox topLevel(context) {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          CustomerSection(controller: controller),
          const SizedBox(
            width: 20,
          ),
          SalesInfo(controller: controller),
          const SizedBox(
            width: 20,
          ),
          ServiceSection(controller: controller)
        ],
      ),
    );
  }
}
