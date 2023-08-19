import '../../../responsive.dart';
import '../../../services/widgets/waiting.dart';

import '../../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../services/constants/color.dart';
import '../../../services/constants/constant.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/widgets/button.dart';
import '../../../services/widgets/dropdown.dart';
import '../../../services/widgets/richtext.dart';
import '../../../services/widgets/textbox.dart';
import '../../../widgets/header/header.dart';
import 'component/controller/controller.dart';
import 'component/print_out/print_out.dart';
import 'component/table.dart';

class EEntry extends GetView<EEntryCon> {
  const EEntry({super.key});

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
                pageName: 'Expenses Entry',
                searchBar: TextField(
                  onChanged: (text) {
                    controller.loading.value = true;
                    controller.loading.value = false;
                    Future.delayed(const Duration(microseconds: 200))
                        .then((value) {
                      controller.ssList = controller.ss.where((data) {
                        var name = data.sub.toLowerCase();
                        var branch = data.branch.toLowerCase();
                        var catt = data.cat.toLowerCase();
                        var type = data.type.toLowerCase();
                        return branch.contains(text.toLowerCase()) ||
                            name.contains(text.toLowerCase()) ||
                            type.contains(text.toLowerCase()) ||
                            catt.contains(text.toLowerCase());
                      }).toList();
                    });
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
                        if (Responsive.isDesktop(context) ||
                            Responsive.isTablet(context))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  if (Utils.access.contains(
                                      Utils.initials("Expenses Entry", 1)))
                                    MButton(
                                      onTap: () {
                                        controller.clearText();
                                        addDialog(context);
                                      },
                                      type: ButtonType.add,
                                    ).hPadding9,
                                  if (Utils.access.contains(
                                      Utils.initials("Expenses Entry", 4)))
                                    MButton(
                                      onTap: () {
                                        searchDialog(context);
                                      },
                                      type: ButtonType.search,
                                    ).hPadding9,
                                ],
                              ),
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
                                  mainText: "Expenses Record ",
                                  subText: "(${controller.ssList.length})")),
                              Row(
                                children: [
                                  IconButton(
                                          onPressed: () => controller.reload(),
                                          icon: const Icon(Icons.refresh))
                                      .hPadding9,
                                  if (Utils.access.contains(
                                      Utils.initials("expenses Entry", 4)))
                                    IconButton(
                                            onPressed: () {
                                              if (controller
                                                  .ssList.isNotEmpty) {
                                                Get.to(() => ExpensesPrint(
                                                      attendanceList:
                                                          controller.ssList,
                                                      title:
                                                          "Expenses Report from ${controller.selectedDate}",
                                                    ));
                                              } else {
                                                Utils().showError(
                                                    "There are no record to print.");
                                              }
                                            },
                                            icon: const Icon(Icons.print))
                                        .hPadding9,
                                ],
                              )
                            ],
                          ).padding3.card,
                        if (Responsive.isMobile(context))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => MyRichText(
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
                                    mainText: "Expenses Record ",
                                    subText: "(${controller.ssList.length})"),
                              ),
                              PopupMenuButton<String>(
                                elevation: 20.0,
                                onSelected: (String newValue) async {
                                  if (newValue == "Add New") {
                                    if (Utils.access.contains(
                                        Utils.initials("Expenses Entry", 1))) {
                                      controller.clearText();
                                      addDialog(context);
                                    } else {
                                      Utils().showError(
                                          "You dont have access to this");
                                    }
                                  } else if (newValue == "Search") {
                                    if (Utils.access.contains(
                                        Utils.initials("Expenses Entry", 4))) {
                                      searchDialog(context);
                                    } else {
                                      Utils().showError(
                                          "You dont have access to this");
                                    }
                                  } else if (newValue == "Refresh") {
                                    controller.reload();
                                  } else if (newValue == "Print") {
                                    if (Utils.access.contains(
                                        Utils.initials("Expenses Entry", 4))) {
                                      if (controller.ssList.isNotEmpty) {
                                        Get.to(() => ExpensesPrint(
                                              attendanceList: controller.ssList,
                                              title:
                                                  "Expenses Report from ${controller.selectedDate}",
                                            ));
                                      } else {
                                        Utils().showError(
                                            "There are no record to print.");
                                      }
                                    } else {
                                      Utils().showError(
                                          "You dont have access to this");
                                    }
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    controller.popUpMenuItems,
                              ),
                            ],
                          ).padding3.card,
                        if (Utils.access
                            .contains(Utils.initials("Expenses Entry", 0)))
                          SizedBox(
                              height: myHeight(context, 1.19),
                              child: const ETable())
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

  searchDialog(BuildContext context) {
    Get.defaultDialog(
        title: "Search records",
        content: Form(
            child: Column(
          children: [
            Obx(() => controller.isCat.value
                ? const MWaiting()
                : DropDownText(
                        hint: "Select income category",
                        label: "Select income category",
                        controller: controller.catItem,
                        onChange: (val) {
                          controller.catSelected = val.toString();
                          controller.getSubCategories(val.toString());
                        },
                        list: controller.catList)
                    .padding9),
            Obx(() => controller.isSCat.value
                ? const MWaiting()
                : DropDownText(
                        hint: "Select income sub category",
                        label: "Select income sub category",
                        controller: controller.subItem,
                        onChange: (val) {
                          controller.sCatSelected = val.toString();
                        },
                        list: controller.suList)
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
                    if (controller.catSelected.isNotEmpty &&
                        controller.sCatSelected.isNotEmpty) {
                      if (controller.sdate.text.isNotEmpty &&
                          controller.edate.text.isNotEmpty) {
                        controller.getSearchData();
                      } else {
                        Utils().showError("Select start date and end date");
                      }
                    } else {
                      Utils().showError("Select a category and a sub category");
                    }
                  },
                  type: ButtonType.search,
                ),
                MButton(
                  onTap: Get.back,
                  type: ButtonType.cancel,
                )
              ],
            ).padding9
          ],
        )));
  }

  addDialog(context) {
    Get.defaultDialog(
        title: "Add  Expenses",
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
                                      controller
                                          .getSubCategories(val.toString());
                                    },
                                    list: controller.catList)
                                .padding9),
                        Obx(() => controller.isSCat.value
                            ? const MWaiting()
                            : DropDownText(
                                    hint: "Select Sub Category",
                                    label: "Select Sub Category",
                                    controller: controller.subItem,
                                    validate: Utils.validator,
                                    onChange: (val) {
                                      controller.subItem.text = val.toString();
                                    },
                                    list: controller.suList)
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
                                controller.dateText.text =
                                    Utils.dateOnly(picked);
                                controller.setDate.value = false;
                                controller.dailyDate =
                                    DateFormat.yMMMMd().format(picked);
                                controller.setDate.value = true;
                              }
                            },
                            child: Obx(
                              () => ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading:
                                    Icon(Icons.calendar_today, color: voilet),
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
            )));
  }
}
