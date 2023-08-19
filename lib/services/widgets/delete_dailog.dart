import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color.dart';
import '../utils/helpers.dart';
import 'button.dart';
import 'extension.dart';

class Delete extends StatelessWidget {
  final String deleteName;
  final VoidCallback ontap;

  const Delete({Key? key, required this.deleteName, required this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: "Are you sure you want to delete ",
            style: TextStyle(
                color: Utils.isLightTheme.value ? dark : light, fontSize: 16),
            children: [
              TextSpan(
                text: deleteName,
                style: const TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MButton(
              onTap: ontap,
              title: "Yes",
              color: Colors.redAccent,
            ),
            MButton(
              onTap: () => Get.back(),
              title: 'No',
              color: Colors.green.shade900,
            )
          ],
        )
      ],
    );
  }
}

class MError extends StatelessWidget {
  final Exception exception;
  const MError({Key? key, required this.exception}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(12)),
      child: exception.toString().toLabel(color: Colors.white, bold: true),
    );
  }
}
