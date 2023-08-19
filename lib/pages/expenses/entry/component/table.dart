import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
import 'print_out/receipt.dart';

class ETable extends GetView<EEntryCon> {
  const ETable({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Obx(() => !controller.loading.value
          ? DataTable2(
              columnSpacing: 12,
              horizontalMargin: 10,
              minWidth: 1200,
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
                  label: "Category".toLabel(bold: true),
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
                  label: "Sub Category".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssList.sort(
                          (item1, item2) => item1.sub.compareTo(item2.sub));
                    } else {
                      controller.ssList.sort(
                          (item1, item2) => item2.sub.compareTo(item1.sub));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Amount".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssList.sort((item1, item2) =>
                          item1.amount.compareTo(item2.amount));
                    } else {
                      controller.ssList.sort((item1, item2) =>
                          item2.amount.compareTo(item1.amount));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Branch".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssList.sort((item1, item2) =>
                          item1.branch.compareTo(item2.branch));
                    } else {
                      controller.ssList.sort((item1, item2) =>
                          item2.branch.compareTo(item1.branch));
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
                          (item1, item2) => item1.des!.compareTo(item2.des!));
                    } else {
                      controller.ssList.sort(
                          (item1, item2) => item2.des!.compareTo(item1.des!));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Date".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssList.sort(
                          (item1, item2) => item1.date.compareTo(item2.date));
                    } else {
                      controller.ssList.sort(
                          (item1, item2) => item2.date.compareTo(item1.date));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Type".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssList.sort(
                          (item1, item2) => item1.type.compareTo(item2.type));
                    } else {
                      controller.ssList.sort(
                          (item1, item2) => item2.type.compareTo(item1.type));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Cheque #".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssList.sort((item1, item2) =>
                          item1.cheque!.compareTo(item2.cheque!));
                    } else {
                      controller.ssList.sort((item1, item2) =>
                          item2.cheque!.compareTo(item1.cheque!));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Entry Date".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssList.sort((item1, item2) =>
                          item1.entryDate.compareTo(item2.entryDate));
                    } else {
                      controller.ssList.sort((item1, item2) =>
                          item2.entryDate.compareTo(item1.entryDate));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  fixedWidth: 150,
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
                    DataCell(controller.ssList[index].cat.toAutoLabel()),
                    DataCell(controller.ssList[index].sub.toAutoLabel()),
                    DataCell(Utils()
                        .formatPrice(controller.ssList[index].amount)
                        .toString()
                        .toAutoLabel()),
                    DataCell(controller.ssList[index].branch.toAutoLabel()),
                    DataCell(
                        controller.ssList[index].date.toString().toAutoLabel()),
                    DataCell(
                        controller.ssList[index].des!.toString().toAutoLabel()),
                    DataCell(controller.ssList[index].type.toAutoLabel()),
                    DataCell(controller.ssList[index].cheque!.toAutoLabel()),
                    DataCell(controller.ssList[index].entryDate
                        .toString()
                        .toAutoLabel()),
                    DataCell(Row(
                      children: [
                        if (Utils.access
                            .contains(Utils.initials("expenses Entry", 2)))
                          IconButton(
                            onPressed: () {
                              controller.catItem.text =
                                  controller.ssList[index].cat;
                              controller.subItem.text =
                                  controller.ssList[index].sub;
                              controller.amount.text =
                                  controller.ssList[index].amount.toString();
                              controller.chequeNo.text =
                                  controller.ssList[index].cheque!;
                              controller.dateText.text =
                                  controller.ssList[index].date;
                              controller.date.text =
                                  controller.ssList[index].date;
                              controller.branch.text =
                                  controller.ssList[index].branch;
                              controller.setDate.value = true;
                              controller.type.text =
                                  controller.ssList[index].type;
                              controller.des.text =
                                  controller.ssList[index].des!;
                              updateDialog(context,
                                  controller.ssList[index].id.toString());
                            },
                            icon: Icon(
                              Icons.edit,
                              color: voilet,
                            ),
                          ),
                        if (Utils.access
                            .contains(Utils.initials("expenses Entry", 4)))
                          IconButton(
                              onPressed: () {
                                controller.type.text =
                                    controller.ssList[index].type;
                                controller.branch.text =
                                    controller.ssList[index].branch;
                                dynamic dt = controller.ssList[index].date;
                                dynamic amt = controller.ssList[index].amount;
                                controller.des.text =
                                    controller.ssList[index].des!;
                                dynamic inID = controller.ssList[index].id;
                                dynamic sItem = controller.ssList[index].sub;
                                Get.to(ExpensesReceipt(
                                    title: "Debit Payment",
                                    type: controller.type.text,
                                    branch: controller.branch.text,
                                    date: DateTime.parse(dt),
                                    amount: amt,
                                    des: controller.des.text,
                                    category: sItem,
                                    invoice: inID));
                              },
                              icon: const Icon(Icons.print)),
                        if (Utils.access
                            .contains(Utils.initials("expenses Entry", 3)))
                          Obx(() => !controller.isDelete.value ||
                                  int.parse(controller.ssList[index].id) !=
                                      int.parse(controller.deleteID)
                              ? IconButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                        title: 'Delete Record',
                                        content: Delete(
                                          deleteName:
                                              (controller.ssList[index].amount)
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
      title: "Edit Expenses",
      barrierDismissible: false,
      content: Form(
        key: controller.eeformKey,
        child: Column(
          children: [
            SizedBox(
              height: myHeight(context, 2.5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(() => controller.isCat.value
                        ? const MWaiting()
                        : DropDownText(
                                hint: "Select  Category",
                                label: "Select  Category",
                                controller: controller.catItem,
                                validate: Utils.validator,
                                onChange: (val) {
                                  controller.catItem.text = val.toString();
                                  controller.getSubCategories(val.toString());
                                },
                                list: controller.catList)
                            .padding9),
                    Obx(() => controller.isCat.value
                        ? const MWaiting()
                        : DropDownText(
                                hint: "Select Sub Category",
                                label: "Select Sub Category",
                                controller: controller.subItem,
                                validate: Utils.validator,
                                onChange: (val) {
                                  controller.subItem.text = val.toString();
                                },
                                list: controller.catList)
                            .padding9),
                    MEdit(
                      hint: "Amount",
                      controller: controller.amount,
                      inputType: TextInputType.number,
                      validate: Utils.validator,
                    ).padding9,
                    InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(), // Refer step 1
                            firstDate: DateTime.parse('2022-09-30'),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            controller.today = picked;

                            // controller.dateText.text = picked.toString();
                            controller.dateText.text = Utils.dateOnly(picked);
                            controller.setDate.value = false;
                            controller.dailyDate =
                                DateFormat.yMMMMd().format(picked);
                            controller.setDate.value = true;
                          }
                        },
                        child: Obx(
                          () => ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: Icon(Icons.calendar_today, color: voilet),
                            title: controller.setDate.value
                                ? "Selected date: ${controller.dateText.text}"
                                    .toLabel()
                                : "Click here to select date".toLabel(),
                          ).vPadding3,
                        ).padding9),
                    DropDownText(
                            hint: "Select Type",
                            label: "Select Type",
                            controller: controller.type,
                            validate: Utils.validator,
                            onChange: (val) {
                              if (val == "Cheque") {
                                controller.type.text = val.toString();
                                controller.isCheque.value = true;
                              } else {
                                controller.type.text = val.toString();
                                controller.chequeNo.clear();
                                controller.isCheque.value = false;
                              }
                            },
                            list: controller.typeList)
                        .padding9,
                    Obx(() => controller.isCheque.value
                        ? MEdit(
                            hint: "Cheque number",
                            controller: controller.chequeNo,
                          ).padding9
                        : Container()),
                    MEdit(
                      hint: "Description",
                      maxLines: 2,
                      controller: controller.des,
                    ).padding9,
                    Utils.userRole == "Super Admin"
                        ? Obx(() => controller.isB.value
                            ? const MWaiting()
                            : DropDownText(
                                    hint: "Select Branch",
                                    label: "Select Branch",
                                    controller: controller.branch,
                                    validate: Utils.validator,
                                    onChange: (val) {
                                      controller.getBid(val.toString());
                                    },
                                    list: controller.bList)
                                .padding9)
                        : Container(),
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
