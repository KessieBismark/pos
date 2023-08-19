import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../services/constants/color.dart';
import '../../../../../services/constants/constant.dart';
import '../../../../../services/utils/helpers.dart';
import '../../../../../services/widgets/button.dart';
import '../../../../../services/widgets/extension.dart';
import '../../../../../services/widgets/textbox.dart';
import '../../../../../services/widgets/waiting.dart';
import '../controllers/users_controller.dart';
import '../model/users_model.dart';

class UserTable extends GetWidget<UsersController> {
  const UserTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(
        () => !controller.getData.value
            ? DataTable2(
                columnSpacing: defaultPadding,
                minWidth: 600,
                headingRowColor:
                    MaterialStateColor.resolveWith((states) => Colors.black12),
                columns: const [
                  DataColumn(
                    label: Text("Name"),
                  ),
                  DataColumn(
                    label: Text("Email"),
                  ),
                  DataColumn(
                    label: Text("Role"),
                  ),
                  DataColumn(
                    label: Text("Access"),
                  ),
                  DataColumn(
                    label: Text("Action"),
                  ),
                ],
                rows: List.generate(
                  controller.usersRecords.length,
                  (index) => recentFileDataRow(
                      controller.usersRecords[index], context),
                ),
              )
            : const MWaiting(),
      ),
    ).card;
  }

  DataRow recentFileDataRow(UsersModel fileInfo, context) {
    UsersController con = Get.find<UsersController>();
    return DataRow(
      cells: [
        DataCell(fileInfo.name!.toAutoLabel()),
        DataCell(fileInfo.email.toAutoLabel()),
        DataCell(fileInfo.role.toAutoLabel()),
        Utils.userRole == "Super Admin" || Utils.uid.value == '1000'
            ? DataCell(IconButton(
                tooltip: "Grant Access",
                onPressed: () {
                  controller.permission.value = [];
                  controller.userName = fileInfo.name!;
                  if (fileInfo.access!.isNotEmpty) {
                    controller.permission.value =
                        ((fileInfo.access!).split(","));
                  }
                  Get.toNamed('/role', arguments: fileInfo.id);
                },
                icon: Icon(
                  FontAwesomeIcons.userLock,
                  color: greenfade,
                )))
            : DataCell(" ".toLabel()),
        DataCell(
          Row(
            children: [
              Utils.userRole == "Super Admin" || Utils.uid.value == '1000'
                  ? IconButton(
                      tooltip: "Change role",
                      onPressed: () {
                        con.email.text = fileInfo.email;
                        changeRoleDialog(fileInfo.id, context);
                      },
                      icon: Icon(
                        FontAwesomeIcons.userPen,
                        color: secondary,
                      ))
                  : Container(),
              const Spacer(),
              Utils.userName == fileInfo.name! &&
                      Utils.userEmail == fileInfo.email
                  ? IconButton(
                      tooltip: "Edit account",
                      onPressed: () {
                        con.email.text = fileInfo.email;
                        showUpdateDialog(fileInfo.id, context);
                      },
                      icon: Icon(
                        Icons.edit,
                        color: voilet,
                      ))
                  : Container(),
              const Spacer(),
              Obx(
                () => !con.deleting.value || fileInfo.id != con.deleteID
                    ? Utils.userRole == "Super Admin" ||
                            Utils.uid.value == '1000'
                        ? Utils.userName != fileInfo.name!
                            ? IconButton(
                                tooltip: "Delete",
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: 'Delete',
                                    content: Column(
                                      children: [
                                        "Are you sure you want to delete ${fileInfo.email}"
                                            .toLabel()
                                            .padding9,
                                        const Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            MButton(
                                              onTap: () {
                                                con.delete(fileInfo.id);
                                                Get.back();
                                              },
                                              title: "Yes",
                                              color: Colors.redAccent,
                                            ),
                                            MButton(
                                              onTap: () => Get.back(),
                                              title: 'No',
                                              color: Colors.green.shade400,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                              )
                            : Container()
                        : Container()
                    : const CupertinoActivityIndicator(),
              )
            ],
          ),
        ),
      ],
    );
  }

  showUpdateDialog(String id, context) {
    UsersController con = Get.find<UsersController>();

    return Get.defaultDialog(
      title: "Update Account",
      content: Form(
        key: con.shopFormKey,
        child: Column(
          children: [
            MEdit(
              hint: "Email",
              controller: con.email,
              validate: con.validator,
            ).padding3,
            MEdit(
              hint: "Password",
              controller: con.password,
              password: true,
              validate: con.validator,
            ).padding3,
            MEdit(
              hint: "Confirm password",
              controller: con.cpassword,
              password: true,
              validate: con.validator,
            ).padding3,
            const Divider().padding9,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => !con.loading.value
                      ? MButton(
                          onTap: () {
                            con.updateUsers(id);
                          },
                          title: 'Update',
                          color: greenfade,
                          icon: const Icon(Icons.edit),
                        )
                      : const CupertinoActivityIndicator(),
                ),
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

  changeRoleDialog(String id, context) {
    UsersController con = Get.find<UsersController>();
    return Get.defaultDialog(
      title: "Change role",
      content: Form(
        key: con.shopFormKey,
        child: Column(
          children: [
            Row(
              children: [
                "Role".toLabel(),
                const Spacer(),
                Obx(
                  () => DropdownButton(
                    hint: 'Role'.toLabel(),
                    onChanged: (newValue) {
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
            ).padding3,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => !con.cRole.value
                    ? MButton(
                        onTap: () {
                          con.changeRole(id);
                        },
                        title: 'Update',
                        color: greenfade,
                        icon: const Icon(Icons.edit),
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
