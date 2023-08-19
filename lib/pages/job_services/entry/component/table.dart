import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/constants/color.dart';
import '../../../../services/constants/constant.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/widgets/button.dart';
import '../../../../services/widgets/delete_dailog.dart';
import '../../../../services/widgets/dropdown.dart';
import '../../../../services/widgets/extension.dart';
import '../../../../services/widgets/textbox.dart';
import '../../../../services/widgets/waiting.dart';
import 'controller/controller.dart';

class ServiceTable extends GetView<ServiceEntryCon> {
  const ServiceTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Obx(() => !controller.loading.value
          ? DataTable2(
              columnSpacing: 12,
              horizontalMargin: 10,
              minWidth: 800,
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
                      controller.sList.sort(
                          (item1, item2) => item1.name.compareTo(item2.name));
                    } else {
                      controller.sList.sort(
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
                      controller.sList.sort(
                          (item1, item2) => item1.des!.compareTo(item2.des!));
                    } else {
                      controller.sList.sort(
                          (item1, item2) => item2.des!.compareTo(item1.des!));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Category".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.sList.sort(
                          (item1, item2) => item1.cat.compareTo(item2.cat));
                    } else {
                      controller.sList.sort(
                          (item1, item2) => item2.cat.compareTo(item1.cat));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Sub category".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.sList.sort(
                          (item1, item2) => item1.sub.compareTo(item2.sub));
                    } else {
                      controller.sList.sort(
                          (item1, item2) => item2.sub.compareTo(item1.sub));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Quantity".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.sList.sort((item1, item2) =>
                          item1.quantity!.compareTo(item2.quantity!));
                    } else {
                      controller.sList.sort((item1, item2) =>
                          item2.quantity!.compareTo(item1.quantity!));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Cost".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.sList.sort(
                          (item1, item2) => item1.cost.compareTo(item2.cost));
                    } else {
                      controller.sList.sort(
                          (item1, item2) => item2.cost.compareTo(item1.cost));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Unit Price".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.sList.sort((item1, item2) =>
                          item1.price!.compareTo(item2.price!));
                    } else {
                      controller.sList.sort((item1, item2) =>
                          item2.price!.compareTo(item1.price!));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Branch".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.sList.sort((item1, item2) =>
                          item1.branch.compareTo(item2.branch));
                    } else {
                      controller.sList.sort((item1, item2) =>
                          item2.branch.compareTo(item1.branch));
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
                controller.sList.length,
                (index) => DataRow(
                  color: index.isEven
                      ? MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(31, 167, 162, 162))
                      : null,
                  cells: [
                    DataCell((index + 1).toString().toAutoLabel()),
                    DataCell(controller.sList[index].name.toAutoLabel()),
                    DataCell(controller.sList[index].des!.toAutoLabel()),
                    DataCell(controller.sList[index].cat.toAutoLabel()),
                    DataCell(controller.sList[index].sub.toAutoLabel()),
                    DataCell(controller.sList[index].quantity!.toAutoLabel()),
                    DataCell(Utils()
                        .formatPrice(controller.sList[index].cost)
                        .toString()
                        .toAutoLabel()),
                    DataCell(Utils()
                        .formatPrice(controller.sList[index].price)
                        .toString()
                        .toAutoLabel()),
                    DataCell(controller.sList[index].branch.toAutoLabel()),
                    DataCell(Row(
                      children: [
                        if (Utils.access
                            .contains(Utils.initials("Products Entry", 2)))
                          IconButton(
                            onPressed: () {
                              controller.name.text =
                                  controller.sList[index].name;
                              controller.des.text =
                                  controller.sList[index].des!;
                              controller.subItem.text =
                                  controller.sList[index].sub;
                              controller.isB.value = true;
                              controller.branch = DropDownModel(
                                  id: controller.sList[index].bid,
                                  name: controller.sList[index].branch);
                              controller.quantity.text =
                                  controller.sList[index].quantity.toString();
                              controller.cost.text =
                                  controller.sList[index].cost.toString();
                              controller.price.text =
                                  controller.sList[index].price.toString();
                              controller.branch = DropDownModel(
                                  id: controller.sList[index].id,
                                  name: controller.sList[index].branch);
                              updateDialog(context,
                                  controller.sList[index].id.toString());
                              controller.isB.value = false;
                            },
                            icon: Icon(
                              Icons.edit,
                              color: voilet,
                            ),
                          ),
                        if (Utils.access
                            .contains(Utils.initials("Products Entry", 3)))
                          Obx(() => !controller.isDelete.value ||
                                  int.parse(controller.sList[index].id) !=
                                      int.parse(controller.deleteID)
                              ? IconButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                        title: 'Delete Record',
                                        content: Delete(
                                          deleteName:
                                              (controller.sList[index].name)
                                                  .toString(),
                                          ontap: () {
                                            controller.delete(controller
                                                .sList[index].id
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
      title: "Edit Product",
      content: Form(
        key: controller.seformKey,
        child: Column(
          children: [
            SizedBox(
              height: myHeight(context, 2.5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MEdit(
                      hint: "Name",
                      controller: controller.name,
                      validate: Utils.validator,
                    ).padding9,
                    Utils.userRole == 'Super Admin'
                        ? Obx(() => DropDownText2(
                              hint: "Select Branch",
                              label: "Select Branch",
                              controller: controller.branch,
                              isLoading: controller.isB.value,
                              validate: true,
                              list: controller.bList,
                              onChange: (DropDownModel? data) {
                                controller.branchID.text = data!.id.toString();
                                controller.branch =
                                    DropDownModel(id: data.id, name: data.name);
                                controller.selBList = data;
                              },
                            ).padding9)
                        : Container(),
                    DropDownText(
                            hint: "Select Sub Category",
                            label: "Select Sub Category",
                            controller: controller.subItem,
                            onChange: (val) {
                              controller.subItem.text = val.toString();
                            },
                            list: controller.subList)
                        .padding9,
                    MEdit(
                      hint: "Quantity",
                      controller: controller.quantity,
                      inputType: TextInputType.number,
                      validate: Utils.validator,
                    ).padding9,
                    MEdit(
                      hint: "Cost",
                      controller: controller.cost,
                      validate: Utils.validator,
                    ).padding9,
                    MEdit(
                      hint: "Unit Price",
                      controller: controller.price,
                      inputType: TextInputType.number,
                      validate: Utils.validator,
                    ).padding9,
                    MEdit(
                      hint: "Description",
                      maxLines: 2,
                      controller: controller.des,
                    ).padding9
                  ],
                ),
              ),
            ),
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
    );
  }
}
