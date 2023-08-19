import 'package:badges/badges.dart' as badges;

import '../../services/constants/color.dart';
import 'component/controller/controller.dart';
import '../../services/constants/constant.dart';
import '../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/utils/helpers.dart';
import '../../services/widgets/button.dart';
import '../../services/widgets/dropdown.dart';
import '../../services/widgets/textbox.dart';
import '../../services/widgets/waiting.dart';
import '../../widgets/drawer/drawer.dart';
import 'cart.dart';

class MobPOS extends GetView<POSCon> {
  const MobPOS({super.key});

  cusDialog(BuildContext context) {
    return Get.defaultDialog(
        title: "Customer Section",
        content: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: myWidth(context, 2.1),
                      child: Obx(() => CusDropDown(
                          hint: "Select customer",
                          label: "Select customer",
                          controller: controller.cusList,
                          isLoading: controller.isCu.value,
                          validate: (CusModel? value) => value == null
                              ? 'Please this field is required'
                              : null,
                          list: controller.cList,
                          onChange: (CusModel? data) {
                            controller.customerID = data!.id.toString();
                            controller.cdiscount = data.discount!;
                            controller.customerPhone = data.contact!;
                            controller.cusList = data;
                            controller.cus.text = data.name;
                            controller
                                .calculateDiscount(controller.total.value);
                          }).padding9),
                    ),
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
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MButton(
                      onTap: () {
                        Get.back();
                        if (controller.cus.text.isNotEmpty &&
                            controller.paymentType.text.isNotEmpty) {
                          Get.to(() => Cart(
                                customer: controller.cus.text,
                                order: controller,
                              ));
                        } else {
                          Utils().showError(
                              "Select a customer and the payment type");
                        }
                      },
                      title: "Continue",
                    ),
                    MButton(
                      onTap: () => Get.back(),
                      type: ButtonType.cancel,
                    )
                  ],
                ).padding9
              ],
            ),
          ],
        ));
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

  Container searchbar() {
    return Container(
      padding: const EdgeInsets.all(7),
      height: 55,
      child: TextField(
          textAlign: TextAlign.left,
          style: const TextStyle(color: Colors.grey),
          controller: controller.search,
          decoration: InputDecoration(
            hintText: "Search item here",
            contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            prefixIcon: const Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
          ),
          onChanged: (text) {
            controller.isService.value = true;
            controller.isService.value = false;
            controller.serList = controller.ss.where((data) {
              var name = data.name.toLowerCase();
              var cat = data.cat.toLowerCase();
              var sub = data.sub.toLowerCase();
              var price = data.cost;

              return name.contains(text.toLowerCase()) ||
                  price.contains(text) ||
                  cat.contains(text.toLowerCase()) ||
                  sub.contains(text.toLowerCase());
            }).toList();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: "POS".toLabel()),
        drawer: const MyDrawer(name: '/sales', selectedItem: '/sales'),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.reload();
          },
          child: SafeArea(
              child: Column(
            children: [
              searchbar(),
              Obx(
                () => controller.isService.value
                    ? Expanded(child: Center(child: const MWaiting().center))
                    : controller.serList.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                                itemCount: controller.listS.length,
                                itemBuilder: (context, index) {
                                  return Obx(() => Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                "NAME: ${controller.listS[index].service}"
                                                    .toAutoLabel(
                                                        bold: true,
                                                        fontsize: 12),
                                                "CATEGORY: ${controller.listS[index].cat} - ${controller.listS[index].sub}"
                                                    .toAutoLabel(fontsize: 9),
                                                "Price: ${Utils().formatPrice(controller.listS[index].price)}"
                                                    .toLabel(bold: true)
                                              ],
                                            ),
                                          ),
                                          if (!controller.products.keys
                                              .toList()
                                              .contains(controller.listS[
                                                  index]))
                                            if (
                                              controller
                                                    .listS[index].quantity >=
                                                (Utils.isNumeric(controller
                                                        .productQuantity(
                                                            controller
                                                                .listS[index]).toString())
                                                    ?int.parse( controller
                                                        .productQuantity(
                                                            controller
                                                                .listS[index]))
                                                    : 0))
                                              IconButton(
                                                  onPressed: () {
                                                    controller.addProduct(
                                                        controller
                                                            .listS[index]);
                                                    controller.getTotal(
                                                        controller.products.keys
                                                            .toList());
                                                  },
                                                  icon: const Icon(Icons.add)),
                                          if (controller.products.keys
                                              .toList()
                                              .contains(
                                                  controller.listS[index]))
                                            IconButton(
                                              icon:
                                                  const Icon(Icons.add_circle),
                                              onPressed: () {
                                                controller.addProduct(
                                                    controller.listS[index]);
                                                controller.getTotal(controller
                                                    .products.keys
                                                    .toList());
                                              },
                                            ),
                                          if (controller
                                                  .productQuantity(
                                                      controller.listS[index])
                                                  .toString() !=
                                              'null')
                                            controller
                                                .productQuantity(
                                                    controller.listS[index])
                                                .toString()
                                                .toLabel(),
                                          if (controller.products.containsKey(
                                              controller.listS[index]))
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.remove_circle),
                                              onPressed: () {
                                                controller.removeProduct(
                                                    controller.listS[index]);
                                                controller.getTotal(controller
                                                    .products.keys
                                                    .toList());
                                              },
                                            ),
                                        ],
                                      ).padding9.card);
                                }),
                          )
                        : Expanded(
                            child: TextButton.icon(
                              onPressed: () => controller.reload(),
                              icon: const Icon(Icons.refresh),
                              label:
                                  "No Data, tap here to refresh".toAutoLabel(),
                            ).center,
                          ),
              ),
            ],
          )),
        ),
        floatingActionButton: badges.Badge(
          position: badges.BadgePosition.topEnd(top: -10, end: 3),
          badgeAnimation: const badges.BadgeAnimation.rotation(
            animationDuration: Duration(seconds: 1),
            colorChangeAnimationDuration: Duration(seconds: 1),
            loopAnimation: false,
            curve: Curves.fastOutSlowIn,
            colorChangeAnimationCurve: Curves.easeInCubic,
          ),
          badgeContent: Obx(() => Text(
                controller.products.length.toString(),
                style: const TextStyle(color: Colors.white),
              )),
          child: FloatingActionButton(
            onPressed: () {
              controller.cus.clear();
              controller.paymentType.clear();
              cusDialog(context);
            },
            elevation: 4.0,
            hoverElevation: 20.0,
            backgroundColor: secondary,
            child: const Icon(Icons.shopping_cart),
          ),
        ));
  }
}
