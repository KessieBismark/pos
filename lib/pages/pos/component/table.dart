import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/widgets/extension.dart';
import '../../../services/utils/helpers.dart';
import 'controller/controller.dart';

class POSTable extends GetView<POSCon> {
  const POSTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Obx(() => DataTable2(
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
                label: "Service ".toLabel(bold: true),
              ),
              DataColumn2(
                label: "Sub Category".toLabel(bold: true),
              ),
              DataColumn2(
                label: "Unit Price".toLabel(bold: true),
              ),
              DataColumn2(
                label: "Sub Total".toLabel(bold: true),
              ),
              DataColumn2(
                label: 'Aciton'.toLabel(bold: true),
              ),
            ],
            rows: List.generate(
              controller.products.keys.toList().length,
              (index) => DataRow(
                color: index.isEven
                    ? MaterialStateColor.resolveWith(
                        (states) => const Color.fromARGB(31, 167, 162, 162))
                    : null,
                cells: [
                  DataCell((index + 1).toString().toAutoLabel()),
                  DataCell(controller.products.keys
                      .toList()[index]
                      .service
                      .toString()
                      .toAutoLabel()),
                  DataCell(controller.products.keys
                      .toList()[index]
                      .sub
                      .toString()
                      .toAutoLabel()),
                  DataCell(Utils()
                      .formatPrice(
                          controller.products.keys.toList()[index].price)
                      .toString()
                      .toAutoLabel()),
                  DataCell(Utils()
                      .formatPrice((double.parse(
                              controller.products.keys.toList()[index].price) *
                          controller.productQuantity(
                              controller.products.keys.toList()[index])))
                      .toString()
                      .toAutoLabel()),
                  DataCell(Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            onPressed: () {
                              controller.addProduct(
                                  controller.products.keys.toList()[index]);
                              controller
                                  .getTotal(controller.products.keys.toList());
                            },
                          ),
                          if (controller
                                  .productQuantity(
                                      controller.products.keys.toList()[index])
                                  .toString() !=
                              'null')
                            controller
                                .productQuantity(
                                    controller.products.keys.toList()[index])
                                .toString()
                                .toLabel(),
                          IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () {
                              controller.removeProduct(
                                  controller.products.keys.toList()[index]);
                              controller
                                  .getTotal(controller.products.keys.toList());
                            },
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            controller.deleteItem(
                                controller.products.keys.toList()[index]);
                            controller
                                .getTotal(controller.products.keys.toList());
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ))
                    ],
                  ))
                ],
              ),
            ),
          )),
    ).card;
  }
}
