import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/widgets/button.dart';
import '../../../services/widgets/extension.dart';
import 'controller/controller.dart';
import 'steppers/accounting/steps.dart';
import 'steppers/job_services/step.dart';
import 'steppers/pos/steps.dart';
import 'steppers/sms/step.dart';

class Role extends GetView<RoleController> {
  const Role({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              "Assign roles for ${controller.name}".toUpperCase().toAutoLabel(),
          actions: [
            MButton(
              onTap: () => controller.insert(),
              type: ButtonType.save,
            ).padding9
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // ExpansionTile(
                  //   title: "Company Branches".toLabel(bold: true),
                  //   children: const [BranchesRole()],
                  // ),
                  ExpansionTile(
                    title: "Sms".toLabel(bold: true),
                    children: const [SmsRole()],
                  ),
                  ExpansionTile(
                    title: "Products".toLabel(bold: true),
                    children: const [ServiceRole()],
                  ),
                  ExpansionTile(
                    title: "Sales".toLabel(bold: true),
                    children: const [PosRole()],
                  ),
                  ExpansionTile(
                    title: "Accounting & Finance".toLabel(bold: true),
                    children: const [AccountRole()],
                  ),
                ],
              )).card,
        ));
  }
}
