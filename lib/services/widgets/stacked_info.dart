import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'extension.dart';

class StackedInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final double boxWidth;
  final double boxHeight;
  final double containerWidth;
  final double containerHeight;
  final Color iconBackColor;
  const StackedInfoCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconBackColor,
    required this.boxWidth,
    required this.boxHeight,
    required this.containerWidth,
    required this.containerHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: boxWidth,
      height: boxHeight,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Positioned(
            top: 20,
            child: Column(
              children: [
                Container(
                  height: containerHeight,
                  // height: Responsive.isDesktop(context) ||
                  //         Responsive.isTablet(context)
                  //     ? 130
                  //     : myHeight(context, 5),
                  width: containerWidth,
                  // width: Responsive.isDesktop(context) ||
                  //         Responsive.isTablet(context)
                  //     ? myWidth(context, 4.5)
                  //     : myWidth(context, 2.5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                    //, Make rounded corner of border
                    border: Border.all(color: iconBackColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      title.capitalizeFirst!
                          .toAutoLabel(bold: true, fontsize: 20),
                      const SizedBox(
                        height: 10,
                      ),
                      value.toAutoLabel(bold: true, fontsize: 30)
                    ],
                  ).padding9,
                ).card,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.topLeft,
              child: Card(
                elevation: 10,
                child: Container(
                  height: 60,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(
                            3.5) //                 <--- border radius here
                        ),
                    color: iconBackColor,
                  ),
                  child: Center(
                      child: Icon(
                    icon,
                    color: Colors.white,
                    size: 45,
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
