import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/constants/color.dart';
import '../../../../services/constants/constant.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/widgets/button.dart';
import '../../../../services/widgets/dropdowntext2.dart';
import '../../../../services/widgets/extension.dart';
import '../../../../services/widgets/richtext.dart';
import '../../../../services/widgets/textbox.dart';
import '../../../../services/widgets/waiting.dart';
import '../controller/controller.dart';
import '../model.dart';
import '../table.dart';

class SalesTable extends StatelessWidget {
  final POSCon controller;
  const SalesTable({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  "Item: ".toLabel(),
                  Form(
                    key: controller.salesKey,
                    child: SizedBox(
                      width: 250,
                      child: Obx(() => ServiceDrop(
                          hint: "Item",
                          label: "Item",
                          controller: controller.selectedItem,
                          isLoading: controller.isService.value,
                          validate: (SalesModel? value) => value == null
                              ? 'Please this field is required'
                              : null,
                          list: controller.sList,
                          onChange: (SalesModel? data) {
                            controller.isPrice.value = true;
                            controller.sales.text = data!.id.toString();
                            controller.selectedItem = data;
                            controller.sales.text = data.name;
                            controller.sub = data.sub!;
                            controller.quantity = data.quantity;
                            controller.price = data.price;
                            controller.serviceID = data.id;
                            controller.isPrice.value = false;
                            controller.seletedCart = null;
                            controller.seletedCart = CartModel(
                                serviceId: data.id,
                                service: data.name,
                                sub: data.sub!,
                                price: data.price.toString());
                          }).padding9),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Obx(
                    () => !controller.isPrice.value
                        ? controller.sub.toLabel(
                            color: Colors.green,
                          )
                        : const MWaiting(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Obx(
                    () => !controller.isPrice.value
                        ? MyRichText(
                            mainText: "Price: ",
                            //  color: Utils.isLightTheme.value
                            //               ? dark
                            //               : light,
                            mainStyle: TextStyle(
                              fontSize: 18,
                              color: Utils.isLightTheme.value ||
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                  ? dark
                                  : light,
                            ),
                            subText: Utils()
                                .formatPrice(controller.price)
                                .toString(),
                            subStyle: const TextStyle(
                              color: Colors.green,
                            ),
                          )
                        : const MWaiting(),
                  )
                ],
              ).padding9,
              SizedBox(
                width: myWidth(context, 9),
                child: MEdit(
                  hint: "Quantity",
                  controller: controller.qty,
                  inputType: TextInputType.number,
                  onChange: (val) {
                    if (!Utils.isNumeric(val)) {
                      controller.qty.text = val.replaceAll(RegExp("\\D"), "");
                      Utils().showError("Quantity must not contain a letter");
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MButton(
                    onTap: () {
                      List<dynamic> list = controller.products.keys.toList();
                      var found = 0;
                      for (int i = 0; i < list.length; i++) {
                        if (list[i].service == controller.sales.text) {
                          found = 1;
                          break;
                        }
                      }
                      if (found == 0) {
                        if (controller.cus.text.isNotEmpty) {
                          if (controller.qty.text.isNotEmpty &&
                              Utils.isNumeric(controller.qty.text)) {
                            if (controller.quantity <
                                int.parse(controller.qty.text)) {
                              Utils().showError(
                                  "Quantity in stock is ${controller.quantity} which is less than what you entered");
                            } else {
                              controller.addProductDesk(controller.seletedCart!,
                                  int.parse(controller.qty.text));
                              controller
                                  .getTotal(controller.products.keys.toList());
                              controller.qty.clear();
                            }
                          } else {
                            Utils().showError(
                                "Please enter the quantity you are selling");
                          }
                        } else {
                          Utils().showError("Select a customer");
                        }
                      } else {
                        Utils().showError(
                            "Item has already been added to cart, update it in the action section");
                      }
                    },
                    title: "Add",
                    icon: const Icon(Icons.add),
                  ),
                ],
              ).padding9
            ],
          ),
          const Expanded(
            child: POSTable(),
          )
        ],
      ).card,
    );
  }
}
