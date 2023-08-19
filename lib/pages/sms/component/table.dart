import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/constants/color.dart';
import '../../../../services/widgets/extension.dart';
import '../../../../services/widgets/waiting.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/widgets/button.dart';
import '../../../services/widgets/dropdown.dart';
import '../../../services/widgets/textbox.dart';
import 'controller/controller.dart';

class SmsTable extends GetView<SmsCon> {
  const SmsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Obx(
        () => !controller.loading.value
            ? DataTable2(
                columnSpacing: 12,
                horizontalMargin: 10,
                minWidth: 600,
                smRatio: 0.75,
                lmRatio: 1.5,
                headingRowColor:
                    MaterialStateColor.resolveWith((states) => Colors.black12),
                sortColumnIndex: controller.sortNameIndex.value,
                sortAscending: controller.sortNameAscending.value,
                columns: [
                  DataColumn2(
                    fixedWidth: 50,
                    size: ColumnSize.S,
                    numeric: true,
                    label: '##'.toLabel(bold: true),
                    // numeric: true,
                  ),
                  DataColumn2(
                    label: "Receiver".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.smsList.sort((item1, item2) =>
                            item1.receiver.compareTo(item2.receiver));
                      } else {
                        controller.smsList.sort((item1, item2) =>
                            item2.receiver.compareTo(item1.receiver));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                  ),
                  DataColumn2(
                    label: "Message".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.smsList.sort(
                            (item1, item2) => item1.meg.compareTo(item2.meg));
                      } else {
                        controller.smsList.sort(
                            (item1, item2) => item2.meg.compareTo(item1.meg));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                  ),
                  DataColumn2(
                    label: "Date".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.smsList.sort(
                            (item1, item2) => item1.date.compareTo(item2.date));
                      } else {
                        controller.smsList.sort(
                            (item1, item2) => item2.date.compareTo(item1.date));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                  ),
                  DataColumn2(
                    label: 'Aciton'.toLabel(bold: true),
                  ),
                ],
                rows: List.generate(
                  controller.smsList.length,
                  (index) => DataRow(
                    color: index.isEven
                        ? MaterialStateColor.resolveWith(
                            (states) => const Color.fromARGB(31, 167, 162, 162))
                        : null,
                    cells: [
                      DataCell((index + 1).toString().toAutoLabel()),
                      DataCell(
                          controller.smsList[index].receiver.toAutoLabel()),
                      DataCell(controller.smsList[index].meg.toAutoLabel()),
                      DataCell(controller.smsList[index].date.toAutoLabel()),
                      DataCell(
                        Row(
                          children: [
                            // if (Utils()
                            //     .access
                            //     .contains(Utils.initials("Category", 2)))
                            IconButton(
                              onPressed: () {
                                controller.meg.text =
                                    controller.smsList[index].meg;
                                reSendDialog(context);
                              },
                              icon: Icon(
                                Icons.forward,
                                color: voilet,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            : const MWaiting(),
      ),
    ).card;
  }

  reSendDialog(context) {
    Get.defaultDialog(
        title: "Resend sms",
        barrierDismissible: false,
        content: SingleChildScrollView(
          child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  DropDownText(
                          hint: "Select Sender type",
                          label: "Select Sender type",
                          controller: controller.type,
                          validate: Utils.validator,
                          onChange: (val) {
                            controller.type.text = val.toString();
                            if (val == 'All customers') {
                              controller.all.value = true;
                              controller.ind.value = false;
                              controller.out.value = false;
                            } else if (val == 'Individual') {
                              controller.all.value = false;
                              controller.ind.value = true;
                              controller.out.value = false;
                            } else {
                              controller.all.value = false;
                              controller.ind.value = false;
                              controller.out.value = true;
                            }
                          },
                          list: controller.tList)
                      .padding9,
                  Obx(() => controller.out.value
                      ? MEdit(
                          hint: "Receiver",
                          controller: controller.receiver,
                          inputType: TextInputType.number,
                          validate: Utils.validator,
                        ).padding9
                      : Container()),
                  Obx(() => controller.ind.value
                      ? DropDownText(
                              hint: "Select a customer",
                              label: "Select a customer",
                              onChange: (val) {
                                controller.cn.text = val.toString();
                              },
                              controller: controller.cn,
                              list: controller.cNames)
                          .padding9
                      : Container()),
                  MEdit(
                    hint: "Message",
                    controller: controller.meg,
                    maxLines: 5,
                    validate: Utils.validator,
                  ).padding9,
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => MButton(
                          onTap: controller.insert,
                          isLoading: controller.isSave.value,
                          type: ButtonType.save,
                        ),
                      ),
                      MButton(
                        onTap: Get.back,
                        type: ButtonType.cancel,
                      )
                    ],
                  )
                ],
              )),
        ));
  }
}
