import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/utils/helpers.dart';
import '../../../../services/widgets/extension.dart';
import '../../../../services/widgets/waiting.dart';
import 'controler.dart';

class SRTable extends GetView<SRCon> {
  const SRTable({super.key});

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
                  label: "Total".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssList.sort(
                          (item1, item2) => item1.total.compareTo(item2.total));
                    } else {
                      controller.ssList.sort(
                          (item1, item2) => item2.total.compareTo(item1.total));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Discount".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssList.sort((item1, item2) =>
                          item1.discount.compareTo(item2.discount));
                    } else {
                      controller.ssList.sort((item1, item2) =>
                          item2.discount.compareTo(item1.discount));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Payable".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssList.sort((item1, item2) =>
                          item1.payable.compareTo(item2.payable));
                    } else {
                      controller.ssList.sort((item1, item2) =>
                          item2.payable.compareTo(item1.payable));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Payment".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssList.sort((item1, item2) =>
                          item1.payment.compareTo(item2.payment));
                    } else {
                      controller.ssList.sort((item1, item2) =>
                          item2.payment.compareTo(item1.payment));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                  label: "Balance".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssList.sort((item1, item2) =>
                          item1.balance.compareTo(item2.balance));
                    } else {
                      controller.ssList.sort((item1, item2) =>
                          item2.balance.compareTo(item1.balance));
                    }
                    controller.sortNameAscending.value = ascending;
                    controller.sortNameIndex.value = columnIndex;
                  },
                ),
                DataColumn2(
                    label: "Customer".toLabel(bold: true),
                    onSort: (int columnIndex, bool ascending) {
                      if (ascending) {
                        controller.ssList.sort((item1, item2) =>
                            item1.customer.compareTo(item2.customer));
                      } else {
                        controller.ssList.sort((item1, item2) =>
                            item2.customer.compareTo(item1.customer));
                      }
                      controller.sortNameAscending.value = ascending;
                      controller.sortNameIndex.value = columnIndex;
                    },
                    tooltip: "Customer name"),
                DataColumn2(
                  label: "Rep".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssList.sort(
                          (item1, item2) => item1.rep.compareTo(item2.rep));
                    } else {
                      controller.ssList.sort(
                          (item1, item2) => item2.rep.compareTo(item1.rep));
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
                  label: "Status".toLabel(bold: true),
                  onSort: (int columnIndex, bool ascending) {
                    if (ascending) {
                      controller.ssList.sort(
                          (item1, item2) => item1.book.compareTo(item2.book));
                    } else {
                      controller.ssList.sort(
                          (item1, item2) => item2.book.compareTo(item1.book));
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
                    DataCell(
                      Utils()
                          .formatPrice(controller.ssList[index].total)
                          .toString()
                          .toAutoLabel(),
                    ),
                    DataCell(
                      Utils()
                          .formatPrice(controller.ssList[index].discount)
                          .toString()
                          .toAutoLabel(),
                    ),
                    DataCell(
                      Utils()
                          .formatPrice(controller.ssList[index].payable)
                          .toString()
                          .toAutoLabel(),
                    ),
                    DataCell(
                      Utils()
                          .formatPrice(controller.ssList[index].payment)
                          .toString()
                          .toAutoLabel(),
                    ),
                    DataCell(
                      Utils()
                          .formatPrice(controller.ssList[index].balance)
                          .toString()
                          .toAutoLabel(),
                    ),
                    DataCell(controller.ssList[index].customer.toAutoLabel()),
                    DataCell(controller.ssList[index].rep.toAutoLabel()),
                    DataCell(controller.ssList[index].branch.toAutoLabel()),
                    DataCell(int.parse(controller.ssList[index].book) == 1
                        ? "Proforma".toLabel(color: Colors.orange)
                        : "Direct sales".toLabel(color: Colors.green)),
                    DataCell(Utils.dateOnly(
                            DateTime.parse(controller.ssList[index].date))
                        .toString()
                        .toAutoLabel()),
                    DataCell(
                      Obx(
                        () => controller.isPrint.value &&
                                controller.invoiceID ==
                                    controller.ssList[index].id
                            ? const MWaiting()
                            : InkWell(
                                child: ClipOval(
                                  child: Container(
                                    color: Colors.orange,
                                    child: " View ".toLabel(),
                                  ).padding3,
                                ),
                                onTap: () {
                                  controller.balance =
                                      controller.ssList[index].balance;
                                  controller.customer =
                                      controller.ssList[index].customer;
                                  controller.discountAmount =
                                      controller.ssList[index].discount;
                                  controller.payable =
                                      controller.ssList[index].payable;
                                  controller.payment =
                                      controller.ssList[index].payment;
                                  controller.total =
                                      controller.ssList[index].total;
                                  controller.rep = controller.ssList[index].rep;
                                  controller.invoiceID =
                                      controller.ssList[index].id.toString();
                                  controller.branch =
                                      controller.ssList[index].branch;
                                  controller.pdate = Utils.dateOnly(
                                      DateTime.parse(
                                          controller.ssList[index].date));
                                  controller.getSalesDetails(
                                      controller.ssList[index].id.toString(),
                                      context);
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const MWaiting()),
    ).card;
  }
}
