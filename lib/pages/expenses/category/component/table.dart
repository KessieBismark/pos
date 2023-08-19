import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/constants/color.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/widgets/button.dart';
import '../../../../services/widgets/delete_dailog.dart';
import '../../../../services/widgets/extension.dart';
import '../../../../services/widgets/textbox.dart';
import '../../../../services/widgets/waiting.dart';
import 'controller/controller.dart';

class ETable extends GetView<ECatCon> {
  const ETable({super.key});

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
                    label: "Name".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.catList.sort(
                            (item1, item2) => item1.name.compareTo(item2.name));
                      } else {
                        controller.catList.sort(
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
                        controller.catList.sort(
                            (item1, item2) => item1.des!.compareTo(item2.des!));
                      } else {
                        controller.catList.sort(
                            (item1, item2) => item2.des!.compareTo(item1.des!));
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
                  controller.catList.length,
                  (index) => DataRow(
                    color: index.isEven
                        ? MaterialStateColor.resolveWith(
                            (states) => const Color.fromARGB(31, 167, 162, 162))
                        : null,
                    cells: [
                      DataCell((index + 1).toString().toAutoLabel()),
                      DataCell(controller.catList[index].name.toAutoLabel()),
                      DataCell(controller.catList[index].des!.toAutoLabel()),
                      DataCell(
                        Row(
                          children: [
                            if (Utils
                                .access
                                .contains(Utils.initials("expenses Category", 2)))

                            IconButton(
                              onPressed: () {
                                controller.name.text =
                                    controller.catList[index].name;
                                controller.des.text =
                                    controller.catList[index].des!;

                                updateDialog(context,
                                    controller.catList[index].id.toString());
                              },
                              icon: Icon(
                                Icons.edit,
                                color: voilet,
                              ),
                            ),
                            if (Utils
                                .access
                                .contains(Utils.initials("expenses Category", 3)))
                            Obx(
                              () => !controller.isDelete.value ||
                                   int.parse(   controller.catList[index].id )!=
                                          int.parse(controller.deleteID)
                                  ? IconButton(
                                      onPressed: () {
                                        Get.defaultDialog(
                                          title: 'Delete Record',
                                          content: Delete(
                                            deleteName:
                                                (controller.catList[index].name)
                                                    .toString(),
                                            ontap: () {
                                              controller.delete(controller
                                                  .catList[index].id
                                                  .toString());
                                              Get.back();
                                            },
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    )
                                  : const MWaiting(),
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

  updateDialog(context, String id) {
    Get.defaultDialog(
      title: "Edit Category",
      content: SingleChildScrollView(
        child: Form(
          key: controller.ecformKey,
          child: Column(
            children: [
              MEdit(
                hint: "Name",
                controller: controller.name,
                validate: Utils.validator,
              ).padding9,
              MEdit(
                hint: "Description",
                controller: controller.des,
              ).padding9,
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
          ),
        ),
      ),
    );
  }
}
