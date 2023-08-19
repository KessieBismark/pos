import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/constants/color.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/widgets/extension.dart';
import '../../../../services/widgets/richtext.dart';
import '../controller/controller.dart';

class SalesInfo extends StatelessWidget {
  final POSCon controller;
  const SalesInfo({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        "Sales Info".toAutoLabel().vPadding6,
        Obx(
          () => MyRichText(
            mainText: "Sales sales: ",
            mainStyle: TextStyle(
              fontSize: 25,
              color: Utils.isLightTheme.value ||
                      Theme.of(context).brightness == Brightness.light
                  ? dark
                  : light,
            ),
            subText: controller.count.value.toString(),
            subStyle: const TextStyle(color: Colors.green),
          ).padding9,
        ),
        Obx(
          () => MyRichText(
            mainText: "Proformal/Saved: ",
            mainStyle: TextStyle(
              fontSize: 25,
              color: Utils.isLightTheme.value ||
                      Theme.of(context).brightness == Brightness.light
                  ? dark
                  : light,
            ),
            subText: controller.booked.value.toString(),
            subStyle: const TextStyle(color: Colors.green),
          ).padding9,
        ),
        Obx(
          () => MyRichText(
            mainText: "Cash @ hand: ",
            mainStyle: TextStyle(
              fontSize: 25,
              color: Utils.isLightTheme.value ||
                      Theme.of(context).brightness == Brightness.light
                  ? dark
                  : light,
            ),
            subText:
                Utils().formatPrice(controller.salesAmount.value).toString(),
            subStyle: const TextStyle(color: Colors.green),
          ).padding9,
        ),
      ],
    ).card);
  }
}
