import '../../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/constants/color.dart';
import '../../../services/constants/constant.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/widgets/button.dart';
import '../../../services/widgets/dropdown.dart';
import '../../../services/widgets/richtext.dart';
import '../../../services/widgets/textbox.dart';
import '../../../widgets/header/header.dart';
import 'component/controller/controller.dart';
import 'component/table.dart';

class ServiceEntry extends GetView<ServiceEntryCon> {
  const ServiceEntry({super.key});

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
                pageName: 'Products Entry',
                searchBar: TextField(
                  onChanged: (text) {
                    controller.loading.value = true;
                    controller.loading.value = false;
                    controller.sList = controller.s.where((data) {
                      var name = data.name.toLowerCase();
                      return name.contains(text.toLowerCase());
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
                                .contains(Utils.initials("Products Entry", 1)))
                              MButton(
                                onTap: () {
                                  controller.clearText();
                                  addDialog(context);
                                },
                                type: ButtonType.add,
                              ).hPadding9,
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
                                mainText: "Product(s) Record ",
                                subText: "(${controller.sList.length})")),
                            Utils.userRole == 'Super Admin'
                                ? SizedBox(
                                    width: 150,
                                    height: 50,
                                    child: Obx(() => DropDownText2(
                                        hint: "Branch",
                                        label: "Branch",
                                        controller: controller.branch,
                                        isLoading: controller.isB.value,
                                        onChange: (DropDownModel? data) {
                                          controller.isB.value = true;
                                          controller.branch = data;
                                          controller.isB.value = false;
                                          controller.getData(data!.id);
                                        },
                                        list: controller.bList)),
                                  )
                                : Container(),
                            IconButton(
                                onPressed: () => controller.reload(),
                                icon: const Icon(Icons.refresh)),
                          ],
                        ).padding3.card,
                        if (Utils.access
                            .contains(Utils.initials("Products Entry", 0)))
                          SizedBox(
                              height: myHeight(context, 1.19),
                              child: const ServiceTable())
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

  addDialog(context) {
    Get.defaultDialog(
      title: "Add Product",
      barrierDismissible: false,
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
                              //  controller.branchID.text = data!.id.toString();
                              controller.branch = data;
                              // controller.selBList = data;
                            }).padding9)
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
        ),
      ),
    );
  }
}
