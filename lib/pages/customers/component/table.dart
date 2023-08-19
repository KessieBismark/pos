import '../../../../services/widgets/extension.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../services/constants/color.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/widgets/button.dart';
import '../../../../services/widgets/delete_dailog.dart';
import '../../../../services/widgets/textbox.dart';
import '../../../../services/widgets/waiting.dart';
import '../../../services/constants/constant.dart';
import 'controller/controller.dart';

class CustomerTable extends GetView<CustomerCon> {
  const CustomerTable({super.key});

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
                      controller.ccList.sort(
                          (item1, item2) => item1.name.compareTo(item2.name));
                    } else {
                      controller.ccList.sort(
                          (item1, item2) => item2.name.compareTo(item1.name));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Email".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ccList.sort((item1, item2) =>
                          item1.email!.compareTo(item2.email!));
                    } else {
                      controller.ccList.sort((item1, item2) =>
                          item2.email!.compareTo(item1.email!));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Contact".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ccList.sort((item1, item2) =>
                          item1.contact!.compareTo(item2.contact!));
                    } else {
                      controller.ccList.sort((item1, item2) =>
                          item2.contact!.compareTo(item1.contact!));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Address".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ccList.sort((item1, item2) =>
                          item1.address!.compareTo(item2.address!));
                    } else {
                      controller.ccList.sort((item1, item2) =>
                          item2.address!.compareTo(item1.address!));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Discount".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ccList.sort((item1, item2) =>
                          item1.discount.compareTo(item2.discount));
                    } else {
                      controller.ccList.sort((item1, item2) =>
                          item2.discount.compareTo(item1.discount));
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
                controller.ccList.length,
                (index) => DataRow(
                  color: index.isEven
                      ? MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(31, 167, 162, 162))
                      : null,
                  cells: [
                    DataCell((index + 1).toString().toAutoLabel()),
                    DataCell(controller.ccList[index].name.toAutoLabel()),
                    DataCell(controller.ccList[index].email!.toAutoLabel()),
                    DataCell(controller.ccList[index].contact!.toAutoLabel()),
                    DataCell(controller.ccList[index].address!.toAutoLabel()),
                    DataCell(controller.ccList[index].discount
                        .toString()
                        .toAutoLabel()),
                    DataCell(Row(
                      children: [
                        if (Utils.access
                            .contains(Utils.initials("customer", 2)))
                          IconButton(
                            onPressed: () {
                              controller.name.text =
                                  controller.ccList[index].name;
                              controller.email.text =
                                  controller.ccList[index].email!;

                              controller.contact.text =
                                  controller.ccList[index].contact!;

                              controller.address.text =
                                  controller.ccList[index].address!;
                              controller.discount.text =
                                  controller.ccList[index].discount.toString();

                              updateDialog(context,
                                  controller.ccList[index].id.toString());
                            },
                            icon: Icon(
                              Icons.edit,
                              color: voilet,
                            ),
                          ),
                        if (Utils.access
                            .contains(Utils.initials("customer", 3)))
                          Obx(() => !controller.isDelete.value ||
                                  int.parse(controller.ccList[index].id) !=
                                      int.parse(controller.deleteID)
                              ? IconButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                        title: 'Delete Record',
                                        content: Delete(
                                          deleteName:
                                              (controller.ccList[index].name)
                                                  .toString(),
                                          ontap: () {
                                            controller.delete(controller
                                                .ccList[index].id
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
      title: "Edit Customer Details",
      content: Form(
          key: controller.cuformKey,
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
                      MEdit(
                        hint: "Email",
                        controller: controller.email,
                        inputType: TextInputType.emailAddress,
                      ).padding9,
                      MEdit(
                        hint: "Contact",
                        controller: controller.contact,
                        inputType: TextInputType.number,
                      ).padding9,
                      MEdit(
                        hint: "Address",
                        controller: controller.address,
                      ).padding9,
                      MEdit(
                        hint: "Discount",
                        controller: controller.discount,
                        inputType: TextInputType.number,
                        validate: Utils.validator,
                      ).padding9,
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
          )),
    );
  }
}
