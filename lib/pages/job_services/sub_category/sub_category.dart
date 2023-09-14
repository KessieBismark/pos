import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/constants/color.dart';
import '../../../services/constants/constant.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/widgets/button.dart';
import '../../../services/widgets/dropdown.dart';
import '../../../services/widgets/extension.dart';
import '../../../services/widgets/richtext.dart';
import '../../../services/widgets/textbox.dart';
import '../../../widgets/header/header.dart';
import 'component/controller/controller.controller.dart';
import 'component/table.dart';

class SSubCategory extends GetView<SSCatCon> {
  const SSubCategory({super.key});

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
                pageName: 'Sub Category',
                searchBar: TextField(
                  onChanged: (text) {
                    controller.loading.value = true;
                    controller.loading.value = false;
                    controller.ssList = controller.ss.where((data) {
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
                            if (Utils.access.contains(
                                Utils.initials("Products Sub Category", 1)))
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
                                    color:
                                        Utils.isLightTheme.value|| Theme.of(context).brightness == Brightness.light  ? dark : light,
                                    fontSize: 15),
                                subStyle: const TextStyle(
                                    color: Colors.red, fontSize: 15),
                                mainText: "Products Sub Category Record ",
                                subText: "(${controller.ssList.length})")),
                            IconButton(
                                onPressed: () => controller.reload(),
                                icon: const Icon(Icons.refresh))
                          ],
                        ).padding3.card,
                           if (Utils.access.contains(
                                Utils.initials("Products Sub Category", 0)))
                        SizedBox(
                            height: myHeight(context, 1.19),
                            child: const SSCTable())
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
        title: "Add Sub Category",
        content: SingleChildScrollView(
          child: Form(
              key: controller.ssformKey,
              child: Column(
                children: [
                  MEdit(
                    hint: "Name",
                    controller: controller.name,
                    validate: Utils.validator,
                  ).padding9,
                  DropDownText(
                          hint: "Select Category",
                          label: "Select Category",
                          controller: controller.catItem,
                          onChange: (val) {
                            controller.catItem.text = val.toString();
                          },
                          list: controller.catList)
                      .padding9,
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
              )),
        ));
  }
}
