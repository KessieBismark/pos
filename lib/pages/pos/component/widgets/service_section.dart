import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../services/widgets/dropdown.dart';
import '../../../../services/widgets/extension.dart';
import '../controller/controller.dart';

class ServiceSection extends StatelessWidget {
  final POSCon controller;

  const ServiceSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        "Date Section".toAutoLabel().vPadding6,
        // Row(
        //   children: [
        //     "Proformal/Saved".toLabel(fontsize: 20),
        //     Obx(() => Checkbox(
        //           value: controller.isBook.value,
        //           onChanged: (val) {
        //             controller.isBook.value = true;
        //             controller.isInstant.value = false;
        //           },
        //         )),
        //   ],
        // ).padding9.center,
        // Row(
        //   children: [
        //     "Instant section".toLabel(fontsize: 20),
        //     Obx(() => Checkbox(
        //           value: controller.isInstant.value,
        //           onChanged: (val) {
        //             controller.isBook.value = false;
        //             controller.isInstant.value = true;
        //           },
        //         )),
        //   ],
        // ).padding9.center,
        Obx(() => DropDownText2(
            hint: "Select Branch",
            label: "Select Branch",
            controller: controller.selBList,
            isLoading: controller.isB.value,
            validate: true,
            list: controller.bList,
            onChange: (DropDownModel? data) {
              controller.branch.text = data!.id.toString();
              controller.selBList = data;
              controller.branchName.text = data.name;
              
            }).padding9),
        Row(
          children: [
            "Date: ".toLabel(fontsize: 20),
            SizedBox(
              width: 230,
              child: InkWell(
                onTap: () async {
                  controller.setDate.value = false;
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: controller.today, // Refer step 1
                    firstDate: DateTime.parse("2022-09-25"),
                    lastDate: DateTime(9999),
                  );
                  if (picked != null) {
                    controller.today = picked;

                    controller.date.text = picked.toString();
                    controller.setDate.value = true;
                    controller.date.text = DateFormat.yMMMMd().format(picked);
                  }
                  String now = DateFormat("yyyy-MM-dd").format(DateTime.now());

                  if (picked == DateTime.parse(now)) {
                    controller.isInstant.value = true;
                    controller.isBook.value = false;
                  } else if (picked != DateTime.parse(now)) {
                    controller.isBook.value = true;
                    controller.isInstant.value = false;
                  }
                },
                child: Obx(
                  () => controller.setDate.value
                      ? controller.date.text.toLabel(fontsize: 18)
                      : controller.date.text.toLabel(fontsize: 18),
                ),
              ),
            ),
          ],
        ).padding9,
      ],
    ).card);
  }
}
