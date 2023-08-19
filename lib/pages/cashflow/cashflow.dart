import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/constants/constant.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/widgets/button.dart';
import '../../../services/widgets/dropdown.dart';
import '../../../services/widgets/extension.dart';
import '../../../widgets/header/header.dart';
import '../../services/widgets/waiting.dart';
import 'component/controller/controller.dart';
import 'component/printing/print.dart';
import 'component/printing/print_year.dart';

class CashFlow extends GetView<CashFlowCon> {
  const CashFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(pageName: 'Cashflow', searchBar: Container()),
              const SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        // if (Responsive.isDesktop(context) ||
                        //     Responsive.isTablet(context))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                if (Utils.access
                                    .contains(Utils.initials("cash flow", 4)))
                                  MButton(
                                    onTap: () {
                                      controller.branch.clear();
                                      controller.isB.value = true;
                                      controller.isB.value = false;
                                      searchMonthDialog(context);
                                    },
                                    title: "Monthly",
                                    type: ButtonType.search,
                                  ).hPadding9,
                                if (Utils.access
                                    .contains(Utils.initials("cash flow", 4)))
                                  MButton(
                                    onTap: () {
                                      controller.branch.clear();
                                      controller.isB.value = true;
                                      controller.isB.value = false;
                                      searchYearDialog(context);
                                    },
                                    title: "Yearly",
                                    type: ButtonType.search,
                                    color: Colors.cyan,
                                  ).hPadding9,
                              ],
                            ),
                            "Report".toAutoLabel().padding9,
                            Container()
                          ],
                        ).padding3.card,
                        if (Utils.access
                            .contains(Utils.initials("cash flow", 0)))
                          Obx(
                            () => controller.pp.value
                                ? SizedBox(
                                    height: myHeight(context, 1.19),
                                    child: controller.printPreviewM.value
                                        ? CashflowPrint(
                                            title:
                                                "Cashflow report on ${controller.selectedMonth.text}",
                                            income: controller.income,
                                            expenses: controller.expenses,
                                            cashBal: controller.cashBalance,
                                            totalCashInflow:
                                                controller.totalIncome,
                                            totalCashOutflow:
                                                controller.totalExpenses,
                                            endCash: controller.endCash,
                                            incomecashBalance:
                                                controller.totalIncomeCash,
                                            netCash: controller.netCash,
                                          )
                                        : YearCashflowPrint(
                                            title:
                                                "Cashflow report on ${controller.yearText.text}",
                                            income: controller.yIncome,
                                            expenses: controller.yExpenses,
                                            cashBal: controller.yCashBalance,
                                            totalCashInflow:
                                                controller.yTotalIncome,
                                            totalCashOutflow:
                                                controller.yTotalExpenses,
                                            endCash: controller.yEndCash,
                                            incomecashBalance:
                                                controller.yTotalIncomeCash,
                                            netCash: controller.yNetCash,
                                          ),
                                  )
                                : SizedBox(
                                    height: myHeight(context, 1.19),
                                    child: "Click on search to populate data"
                                        .toLabel()
                                        .center),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  searchMonthDialog(BuildContext context) {
    Get.defaultDialog(
        title: "Search Monthly",
        content: Form(
            child: Column(
          children: [
            Obx(() => DropDownText2(
                hint: "Select Branch",
                label: "Select Branch",
                controller: controller.selBList,
                isLoading: controller.isB.value,
                validate: true,
                list: controller.bList,
                onChange: (DropDownModel? data) {
                  controller.branchID.text = data!.id.toString();
                  controller.branch.text = data.id.toString();
                  controller.getCloseSales(data.id);
                  controller.selBList = data;
                }).padding9),
            Obx(() => controller.isCS.value
                ? const MWaiting()
                : DropDownText(
                        hint: "Select Month",
                        label: "Select Month",
                        controller: controller.selectedMonth,
                        onChange: (val) {
                          controller.selectedMonth.text = val.toString();
                        },
                        list: controller.closeList)
                    .padding9),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => controller.isMonthPrint.value
                    ? const MWaiting()
                    : MButton(
                        onTap: () {
                          if (controller.branch.text.isNotEmpty &&
                              controller.selectedMonth.text.isNotEmpty) {
                            var spliter = [];
                            spliter = controller.selectedMonth.text.split(" ");
                            String newDate =
                                "${spliter[1]}-${Utils.myMonthNumber(spliter[0])}-28";
                            controller.printPreviewY.value = false;
                            controller.monthlyCashflow(newDate);
                          } else {
                            Utils().showError("Select branch and closed month");
                          }
                        },
                        type: ButtonType.search,
                      )),
                MButton(
                  onTap: Get.back,
                  type: ButtonType.cancel,
                )
              ],
            ).padding9
          ],
        )));
  }

  searchYearDialog(BuildContext context) {
    Get.defaultDialog(
        title: "Search Yearly",
        content: Column(
          children: [
            Obx(() => DropDownText2(
                hint: "Select Branch",
                label: "Select Branch",
                controller: controller.selBList,
                isLoading: controller.isB.value,
                validate:true,
                list: controller.bList,
                onChange: (DropDownModel? data) {
                  controller.branchID.text = data!.id.toString();
                  controller.selBList = data;
                 controller. getYear(data.id);
                }).padding9),
            Obx(() => controller.isYear.value
                ? const MWaiting()
                : DropDownText(
                        hint: "Select Year",
                        label: "Select Year",
                        controller: controller.yearText,
                        onChange: (val) =>
                            controller.yearText.text = val.toString(),
                        list: controller.yearList)
                    .padding9),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => controller.isYearPrint.value
                    ? const MWaiting()
                    : MButton(
                        onTap: () {
                          if (controller.yearText.text.isNotEmpty) {
                            controller.printPreviewM.value = false;

                            controller.yearlyCashflow(controller.yearText.text);
                          } else {
                            Utils().showError("Select a year");
                          }
                        },
                        type: ButtonType.search,
                      )),
                MButton(
                  onTap: Get.back,
                  type: ButtonType.cancel,
                )
              ],
            ).padding9
          ],
        ));
  }
}
