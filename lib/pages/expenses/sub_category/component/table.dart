import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/constants/color.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/widgets/button.dart';
import '../../../../services/widgets/delete_dailog.dart';
import '../../../../services/widgets/dropdown.dart';
import '../../../../services/widgets/extension.dart';
import '../../../../services/widgets/textbox.dart';
import '../../../../services/widgets/waiting.dart';
import 'controller/controller.controller.dart';

class ESCTable extends GetView<ESCatCon> {
  const ESCTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Obx(() => !controller.loading.value
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
                  label: "Name".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssList.sort(
                          (item1, item2) => item1.name.compareTo(item2.name));
                    } else {
                      controller.ssList.sort(
                          (item1, item2) => item2.name.compareTo(item1.name));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Description".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssList.sort(
                          (item1, item2) => item1.cat.compareTo(item2.cat));
                    } else {
                      controller.ssList.sort(
                          (item1, item2) => item2.cat.compareTo(item1.cat));
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
                controller.ssList.length,
                (index) => DataRow(
                  color: index.isEven
                      ? MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(31, 167, 162, 162))
                      : null,
                  cells: [
                    DataCell((index + 1).toString().toAutoLabel()),
                    DataCell(controller.ssList[index].name.toAutoLabel()),
                    DataCell(controller.ssList[index].cat.toAutoLabel()),
                    DataCell(Row(
                      children: [
                        if (Utils.access.contains(
                            Utils.initials("expenses Sub Category", 2)))
                          IconButton(
                            onPressed: () {
                              controller.name.text =
                                  controller.ssList[index].name;
                              controller.catItem.text =
                                  controller.ssList[index].cat;

                              updateDialog(context,
                                  controller.ssList[index].id.toString());
                            },
                            icon: Icon(
                              Icons.edit,
                              color: voilet,
                            ),
                          ),
                        if (Utils.access.contains(
                            Utils.initials("expenses Sub Category", 3)))
                          Obx(() => !controller.isDelete.value ||
                                int.parse(  controller.ssList[index].id) !=
                                      int.parse(controller.deleteID)
                              ? IconButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                        title: 'Delete Record',
                                        content: Delete(
                                          deleteName:
                                              (controller.ssList[index].name)
                                                  .toString(),
                                          ontap: () {
                                            controller.delete(controller
                                                .ssList[index].id
                                                .toString());
                                            Get.back();
                                          },
                                        ));
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                )
                              : const MWaiting()),
                      ],
                    ))
                  ],
                ),
              ),
            )
          : const MWaiting()),
    ).card;
  }

  updateDialog(context, String id) {
    Get.defaultDialog(
        title: "Edit Sub Category",
        content: SingleChildScrollView(
          child: Form(
              key: controller.esformKey,
              child: Column(
                children: [
                  MEdit(
                    hint: "Name",
                    controller: controller.name,
                    validate: Utils.validator,
                  ).padding9,
                  DropDownText(
                          hint: "Select Category",
                          label: "Select Category",
                          controller: controller.catItem,
                          onChange: (val) {
                            controller.catItem.text = val.toString();
                          },
                          list: controller.catList)
                      .padding9,
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => MButton(
                          onTap: () => controller.updateData(id),
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
