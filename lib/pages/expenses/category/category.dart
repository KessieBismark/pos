import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/constants/color.dart';
import '../../../services/constants/constant.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/widgets/button.dart';
import '../../../services/widgets/extension.dart';
import '../../../services/widgets/richtext.dart';
import '../../../services/widgets/textbox.dart';
import '../../../widgets/header/header.dart';
import 'component/controller/controller.dart';
import 'component/table.dart';

class ECategory extends GetView<ECatCon> {
  const ECategory({super.key});

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
                pageName: 'Expenses Category',
                searchBar: TextField(
                  onChanged: (text) {
                    controller.loading.value = true;
                    controller.loading.value = false;
                    controller.catList = controller.cat.where((data) {
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
                                Utils.initials("expenses Category", 1)))
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
                                mainText: "Expenses Category Record ",
                                subText: "(${controller.catList.length})")),
                            IconButton(
                                onPressed: () => controller.reload(),
                                icon: const Icon(Icons.refresh))
                          ],
                        ).padding3.card,
                        if (Utils.access.contains(
                                Utils.initials("expenses Category", 0)))
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

  addDialog(context) {
    Get.defaultDialog(
        title: "Add Category",
        content: SingleChildScrollView(
          child: Form(
              key: controller.ecformKey,
              child: Column(
                children: [
                  MEdit(
                    hint: "Name",
                    controller: controller.name,
                    validate: Utils.validator,
                  ).padding9,
                  MEdit(
                    hint: "Description",
                    controller: controller.des,
                  ).padding9,
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
