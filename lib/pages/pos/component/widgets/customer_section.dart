import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/utils/helpers.dart';
import '../../../../services/widgets/button.dart';
import '../../../../services/widgets/dropdown.dart';
import '../../../../services/widgets/extension.dart';
import '../../../../services/widgets/textbox.dart';
import '../controller/controller.dart';

class CustomerSection extends StatelessWidget {
  final POSCon controller;
  const CustomerSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        "Customer Section".toAutoLabel().vPadding6,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 200,
              child: Obx(() => CusDropDown(
                  hint: "Select customer",
                  label: "Select customer",
                  controller: controller.cusList,
                  isLoading: controller.isCu.value,
                  validate: (CusModel? value) =>
                      value == null ? 'Please this field is required' : null,
                  list: controller.cList,
                  onChange: (CusModel? data) {
                    controller.customerID = data!.id.toString();
                    controller.cdiscount = data.discount!;
                    controller.customerPhone = data.contact!;
                    controller.cusList = data;
                    controller.cus.text = data.name;
                    controller.calculateDiscount(controller.total.value);
                  })),
            ).padding9,
            IconButton(
              onPressed: () => controller.reload(),
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: () => addDialog(),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        DropDownText(
                hint: "Select Payment method",
                label: "Select Payment method",
                onChange: (val) {
                  controller.paymentType.text = val.toString();
                },
                controller: controller.paymentType,
                list: controller.pay)
            .padding9,
      ],
    ).card);
  }

   addDialog() {
    Get.defaultDialog(
      title: "Add Customer Details",
      barrierDismissible: false,
      content: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              MEdit(
                hint: "Name",
                controller: controller.name,
                validate: Utils.validator,
              ).padding9,
              MEdit(
                hint: "Email",
                controller: controller.email,
                inputType: TextInputType.emailAddress,
              ).padding9,
              MEdit(
                hint: "Contact",
                controller: controller.contact,
                inputType: TextInputType.number,
              ).padding9,
              MEdit(
                hint: "Address",
                controller: controller.address,
              ).padding9,
              MEdit(
                hint: "Discount",
                controller: controller.discount,
                inputType: TextInputType.number,
                validate: Utils.validator,
              ).padding9,
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => MButton(
                      onTap: controller.insertCustomer,
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
      ),
    );
  }
}
