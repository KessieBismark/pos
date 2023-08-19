import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../services/constants/color.dart';
import '../../../../../services/widgets/extension.dart';
import '../../../users/component/controllers/users_controller.dart';
import 'h_controller.dart';

UsersController user = Get.find();

final con = Get.put(HRRoleController());

class ServiceRole extends StatelessWidget {
  const ServiceRole({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Obx(() => Stepper(
              controlsBuilder:
                  (BuildContext context, ControlsDetails controls) {
                return Row(
                  children: <Widget>[
                    Container(),
                  ],
                );
              },
              elevation: 20.0,
              margin: const EdgeInsets.all(20),
              steps: stepList(),
              currentStep: con.currentStep.value,
              onStepTapped: (index) {
                con.currentStep.value = index;
              },
            )));
  }

  List<Step> stepList() => [
        for (int j = 0; j < con.title.length; j++)
          Step(
            title: con.title[j]
                .toUpperCase()
                .toLabel(bold: true, color: secondary),
            content: Wrap(
              direction: Axis.horizontal,
              runSpacing: 8,
              children: [
                for (int i = 0; i < con.setions.length; i++)
                  Obx(
                    () => SwitchListTile(
                        title: con.setions[i].toUpperCase().toAutoLabel(),
                        value: user.permission
                                .contains(con.initials(con.title[j], i))
                            ? true
                            : false,
                        onChanged: (val) => con.toggle2(i, con.title[j])),
                  ),
              ],
            ).padding9,
          ),
      ];
}
