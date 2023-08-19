import '../../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/constants/color.dart';
import '../../../services/constants/constant.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/widgets/button.dart';
import '../../../services/widgets/richtext.dart';
import '../../../widgets/header/header.dart';
import '../../services/widgets/dropdown.dart';
import '../../services/widgets/textbox.dart';
import 'component/controller/controller.dart';
import 'component/table.dart';

class SMS extends GetView<SmsCon> {
  const SMS({super.key});

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
                pageName: 'SMS Portal',
                searchBar: TextField(
                  onChanged: (text) {
                    controller.loading.value = true;
                    controller.loading.value = false;
                    controller.smsList = controller.sms.where((data) {
                      var name = data.receiver.toLowerCase();
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
                                .contains(Utils.initials("sms portal", 1)))
                              Row(
                                children: [
                                  MButton(
                                    onTap: () {
                                      controller.clearText();
                                      addDialog(context);
                                    },
                                    type: ButtonType.add,
                                  ).hPadding9,
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Utils.userRole == "Super Admin"
                                      ? MButton(
                                          onTap: () {
                                            controller.getAPI().then((value) {
                                              apiDialog(context);
                                            });
                                          },
                                          title: "Sms settings",
                                          icon: const Icon(Icons.settings),
                                          color: const Color.fromARGB(
                                              255, 83, 68, 21),
                                        ).hPadding9
                                      : Container(),
                                ],
                              ),
                            Obx(() => MyRichText(
                                load: controller.loading.value,
                                mainStyle: TextStyle(
                                    color:
                                        Utils.isLightTheme.value || Theme.of(context).brightness == Brightness.light ? dark : light,
                                    fontSize: 15),
                                subStyle: const TextStyle(
                                    color: Colors.red, fontSize: 15),
                                mainText: "SMS ",
                                subText: "(${controller.smsList.length})")),
                            IconButton(
                                onPressed: () => controller.reload(),
                                icon: const Icon(Icons.refresh))
                          ],
                        ).padding3.card,
                        if (Utils.access
                            .contains(Utils.initials("sms portal", 0)))
                          SizedBox(
                              height: myHeight(context, 1.19),
                              child: const SmsTable())
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
        title: "Send sms",
        barrierDismissible: false,
        content: SingleChildScrollView(
          child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  DropDownText(
                          hint: "Select Sender type",
                          label: "Select Sender type",
                          controller: controller.type,
                          validate: Utils.validator,
                          onChange: (val) {
                            controller.type.text = val.toString();
                            if (val == 'All customers') {
                              controller.all.value = true;
                              controller.ind.value = false;
                              controller.out.value = false;
                            } else if (val == 'Individual') {
                              controller.all.value = false;
                              controller.ind.value = true;
                              controller.out.value = false;
                            } else {
                              controller.all.value = false;
                              controller.ind.value = false;
                              controller.out.value = true;
                            }
                          },
                          list: controller.tList)
                      .padding9,
                  Obx(() => controller.out.value
                      ? MEdit(
                          hint: "Receiver",
                          controller: controller.receiver,
                          inputType: TextInputType.number,
                          validate: Utils.validator,
                        ).padding9
                      : Container()),
                  Obx(() => controller.ind.value
                      ? DropDownText(
                              hint: "Select a customer",
                              label: "Select a customer",
                              onChange: (val) {
                                controller.cn.text = val.toString();
                              },
                              controller: controller.cn,
                              list: controller.cNames)
                          .padding9
                      : Container()),
                  MEdit(
                    hint: "Message",
                    controller: controller.meg,
                    maxLines: 5,
                    validate: Utils.validator,
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

  apiDialog(context) {
    Get.defaultDialog(
        title: "SMS API",
        barrierDismissible: true,
        content: SingleChildScrollView(
          child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  MEdit(
                    hint: "Header",
                    controller: controller.header,
                  ).padding9,
                  MEdit(
                    hint: "API",
                    controller: controller.api,
                  ).padding9,
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => MButton(
                          onTap: controller.insertAPI,
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
