import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../services/constants/color.dart';
import '../../../services/constants/constant.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/widgets/extension.dart';
import '../../../services/widgets/richtext.dart';
import '../../../widgets/header/header.dart';
import '../../services/widgets/button.dart';
import '../../services/widgets/dropdown.dart';
import 'component/controler/controller.dart';
import 'component/print/report.dart';
import 'component/table.dart';

class Booking extends GetView<BookingCon> {
  const Booking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(
                pageName: 'Pending Sales Report',
                searchBar: TextField(
                  onChanged: (text) {
                    controller.loading.value = true;
                    controller.loading.value = false;
                    controller.ssList = controller.ss.where((data) {
                      var name = data.date;
                      var rep = data.rep.toLowerCase();
                      var cus = data.customer.toLowerCase();
                      var branch = data.branch.toLowerCase();
                      return name.contains(text) ||
                          rep.contains(text.toLowerCase()) ||
                          cus.contains(text.toLowerCase()) ||
                          branch.contains(text.toLowerCase());
                    }).toList();
                  },
                  decoration: const InputDecoration(
                    hintText: "Search",
                    // fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
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
                            if (Utils.access
                                .contains(Utils.initials("sales report", 4)))
                              MButton(
                                onTap: () => searchData(context),
                                type: ButtonType.search,
                              ).hPadding9,
                            if (Utils.access
                                .contains(Utils.initials("Pending Sales", 1)))
                              Obx(() => MyRichText(
                                  load: controller.loading.value,
                                  mainStyle: TextStyle(
                                      color: Utils.isLightTheme.value ||
                                              Theme.of(context).brightness ==
                                                  Brightness.light
                                          ? dark
                                          : light,
                                      fontSize: 15),
                                  subStyle: const TextStyle(
                                      color: Colors.red, fontSize: 15),
                                  mainText: "Pending Record ",
                                  subText: "(${controller.ssList.length})")),
                            if (Utils.access
                                .contains(Utils.initials("sales report", 4)))
                              IconButton(
                                      onPressed: () {
                                        if (controller.ssList.isNotEmpty) {
                                          Get.to(() => SalesPrint(
                                                attendanceList:
                                                    controller.ssList,
                                                title:
                                                    "Proforma Report From ${controller.selectedDate}",
                                              ));
                                        } else {
                                          Utils().showError(
                                              "There are no record to print.");
                                        }
                                      },
                                      icon: const Icon(Icons.print))
                                  .hPadding9,
                          ],
                        ).padding3.card,
                        if (Utils.access
                            .contains(Utils.initials("Pending Sales", 0)))
                          SizedBox(
                              height: myHeight(context, 1.19),
                              child: const SRTable())
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

  searchData(context) {
    return Get.defaultDialog(
        title: "Search Records",
        content: Column(
          children: [
            Obx(() => DropDownText2(
                hint: "Select Branch",
                label: "Select Branch",
                controller: controller.selBList,
                isLoading: controller.isB.value,
                validate: 
                true,
                list: controller.bList,
                onChange: (DropDownModel? data) {
                  controller.branchID.text = data!.id.toString();
                  controller.selBList = data;
                }).padding9),
            Obx(() => DropDownText(
                    hint: "select sales type",
                    label: "select sales type",
                    controller: controller.selST.value,
                    onChange: (val) {
                      controller.selST.value.text = val!;
                    },
                    list: controller.st)
                .padding9),
            Obx(() => InkWell(
                  onTap: () async {
                    showDateRangePicker(
                            context: context,
                            firstDate: DateTime.parse("2022-11-01"),
                            lastDate: DateTime(9999))
                        .then((value) {
                      if (value != null) {
                        controller.setDate.value = false;
                        DateTimeRange fromRange = DateTimeRange(
                            start: DateTime.now(), end: DateTime.now());
                        fromRange = value;
                        controller.selectedDate =
                            "${DateFormat.yMMMd().format(fromRange.start)} - ${DateFormat.yMMMd().format(fromRange.end)}";
                        controller.sdate.text =
                            DateFormat.yMMMd().format(fromRange.start);
                        controller.edate.text =
                            DateFormat.yMMMd().format(fromRange.end);
                        controller.fromDate = fromRange.start;
                        controller.toDate = fromRange.end;
                      }
                      if (controller.selectedDate.isEmpty) {
                        controller.setDate.value = false;
                      } else {
                        controller.setDate.value = true;
                      }
                    });
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading:
                        const Icon(Icons.calendar_today, color: secondaryColor),
                    title: controller.setDate.value
                        ? controller.selectedDate.toLabel()
                        : "Click here to select date range".toLabel(),
                  ).vPadding3,
                )).padding9,
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MButton(
                  onTap: () {
                    if (controller.branchID.text.isNotEmpty ||
                        controller.edate.text.isNotEmpty ||
                        controller.sdate.text.isNotEmpty) {
                      controller.searchData();
                      Get.back();
                    } else {
                      Utils().showError("Please select branch and date range");
                    }
                  },
                  type: ButtonType.search,
                ),
                MButton(
                  onTap: () => Get.back(),
                  type: ButtonType.cancel,
                )
              ],
            ).padding9
          ],
        ));
  }
}
