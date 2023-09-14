import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/constants/constant.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/widgets/button.dart';
import '../../../services/widgets/dropdown.dart';
import '../../../services/widgets/extension.dart';
import '../../../services/widgets/textbox.dart';
import '../../../widgets/header/header.dart';
import 'component/controllers/users_controller.dart';
import 'component/widget/users_table.dart';

class Users extends GetView<UsersController> {
  const Users({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              pageName: 'Users',
              searchBar: TextField(
                onChanged: (text) {
                  controller.loading.value = true;
                  controller.loading.value = false;
                  controller.usersRecords = controller.users.where((data) {
                    var name = data.name!.toLowerCase();
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Utils.userRole == "Super Admin" ||
                                    Utils.uid.value == '1000'
                                ? MButton(
                                    onTap: () {
                                      controller.name.text = '';
                                      controller.password.text = '';
                                      controller.cpassword.text = '';
                                      controller.email.text = '';
                                      showDialog(context);
                                    },
                                    type: ButtonType.add,
                                    icon: const Icon(Icons.add),
                                  ).hMargin9.hMargin9
                                : Container(),
                            Text(
                              "List Of Users",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            IconButton(
                                onPressed: () => controller.reload(),
                                icon: const Icon(Icons.refresh)),
                          ],
                        ).card,
                        SizedBox(
                            height: myHeight(context, 1.3),
                            child: const UserTable()),
                      ],
                    ),
                  ),
                ),
                // if (!Responsive.isMobile(context))
                //   SizedBox(width: defaultPadding),
                // // On Mobile means if the screen is less than 850 we dont want to show it
                // if (!Responsive.isMobile(context))
                //   Expanded(
                //     flex: 2,
                //     child: StarageDetails(),
                //   ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showDialog(context) {
    return Get.defaultDialog(
      title: "Add New User",
      content: Form(
        key: controller.shopFormKey,
        child: Column(
          children: [
            MEdit(
              hint: "Email",
              controller: controller.email,
              inputType: TextInputType.emailAddress,
              validate: controller.validator,
            ).padding9,
            MEdit(
              hint: "Contact",
              controller: controller.contact,
              validate: controller.validator,
              inputType: TextInputType.number,
            ).padding9,
            Row(
              children: [
                "Select role".toLabel(),
                const Spacer(),
                Obx(
                  () => DropdownButton(
                    hint: 'Select role'.toLabel(),
                    onChanged: (newValue) {
                      if (newValue != "Super Admin") {
                        controller.isAdmin.value = true;
                      } else {
                        controller.isAdmin.value = false;
                      }
                      controller.setSelected(
                        newValue.toString(),
                      );
                    },
                    value: controller.genSelected.value,
                    items: [
                      for (var data in controller.pass)
                        DropdownMenuItem(
                          value: data,
                          child: Text(
                            data,
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ).padding9,
            Utils.userRole != "Super Admin"
                ?Obx(() => !controller.isAdmin.value
                    ? Container()
                    : Obx(() => DropDownText(
                            hint: "Select Branch",
                            label: "Select Branch",
                            controller: controller.branch,
                            validate: Utils.validator,
                            onChange: (val) {
                              controller.getBid(val.toString());
                            },
                            list: controller.bList)
                        .padding9))
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => !controller.loading.value
                    ? MButton(
                        onTap: () {
                          controller.insert();
                        },
                        type: ButtonType.save,
                      )
                    : const CupertinoActivityIndicator()),
                MButton(
                  onTap: () => Get.back(),
                  type: ButtonType.cancel,
                ),
              ],
            ).padding9
          ],
        ),
      ),
    );
  }
}
