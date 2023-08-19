import '../controller/controller.dart';
import '../../../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

import '../../../../services/constants/color.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/widgets/button.dart';
import '../../../../services/widgets/dropdown.dart';
import '../../../../services/widgets/richtext.dart';
import '../printing/print_class.dart';

class TotalSection extends StatelessWidget {
  final POSCon controller;
  const TotalSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 150,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (Utils.access.contains(Utils.initials("sales", 3)) ||
                  Utils.userRole == "Super Admin")
                ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.deepOrangeAccent)),
                        onPressed: () {
                          if (controller.products.isNotEmpty) {
                            Utils.userRole == "Super Admin"
                                ? proformalbranches(context)
                                : controller.bookService().then((value) =>
                                    printDialog(context,
                                        controller.products.keys.toList()));
                          } else {
                            Utils().showError("Cart is empty");
                          }
                        },
                        icon: const Icon(Icons.book_outlined),
                        label: "Proforma/Save".toLabel())
                    .padding9,
              const SizedBox(
                height: 15,
              ),
              if (Utils.access.contains(Utils.initials("sales", 2)) ||
                  Utils.userRole == "Super Admin")
                Obx(() => ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 29, 109, 31))),
                    onPressed: controller.isBook.value
                        ? null
                        : () {
                            if (controller.payment.text.isNotEmpty) {
                              if (controller.paymentType.text.isNotEmpty) {
                                if (controller.products.isNotEmpty) {
                                  if ((double.parse(controller.payment.text) -
                                          (controller.payable.value) >=
                                      0)) {
                                    Utils.userRole == "Super Admin"
                                        ? branches(context)
                                        : controller.sellService().then(
                                            (value) => printDialog(
                                                context,
                                                controller.products.keys
                                                    .toList()));
                                  } else {
                                    Utils().showError(
                                        "Payment is less than amount payable");
                                  }
                                } else {
                                  Utils().showError("Cart is empty");
                                }
                              } else {
                                Utils().showError("Select payment method");
                              }
                            } else {
                              Utils().showError(
                                  "You must enter the amount given to you by the customer");
                            }
                          },
                    icon: const Icon(Icons.money_rounded),
                    label: " Make Sales        ".toLabel()))
            ],
          ),
        ).card,
        SizedBox(
          height: 150,
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(() => MyRichText(
                    mainText: "Total Amount: ",
                    mainStyle: TextStyle(
                      fontSize: 17,
                      color: Utils.isLightTheme.value ||
                              Theme.of(context).brightness == Brightness.light
                          ? dark
                          : light,
                    ),
                    subText: Utils().formatPrice(controller.total.value),
                    subStyle: const TextStyle(
                      color: Colors.green,
                    ),
                  ).padding3),
              Obx(() => MyRichText(
                    mainText: "Discount Amount: ",
                    mainStyle: TextStyle(
                      fontSize: 17,
                      color: Utils.isLightTheme.value ||
                              Theme.of(context).brightness == Brightness.light
                          ? dark
                          : light,
                    ),
                    subText:
                        Utils().formatPrice(controller.discountAmount.value),
                    subStyle: const TextStyle(
                      color: Colors.green,
                    ),
                  ).padding3),
              Obx(() => MyRichText(
                    mainText: "Amount Payable: ",
                    mainStyle: TextStyle(
                      fontSize: 17,
                      color: Utils.isLightTheme.value ||
                              Theme.of(context).brightness == Brightness.light
                          ? dark
                          : light,
                    ),
                    subText: Utils().formatPrice(controller.payable.value),
                    subStyle: const TextStyle(
                      color: Colors.green,
                    ),
                  ).padding3),
              Row(
                children: [
                  const Spacer(),
                  "Payment: ".toAutoLabel(fontsize: 17).padding3,
                  SizedBox(
                    height: 20,
                    width: 100,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: controller.payment,
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          if (Utils.isNumeric(val)) {
                            controller.balance.value =
                                double.parse(val) - controller.payable.value;
                          } else {
                            controller.payment.text =
                                val.replaceAll(RegExp("\\D"), "");
                            Utils().showError(
                                "Payment amount must not contain a letter");
                          }
                        }
                      },
                    ),
                  ).padding3,
                ],
              ),
              Obx(() => MyRichText(
                    mainText: "Balance: ",
                    mainStyle: TextStyle(
                      fontSize: 17,
                      color: Utils.isLightTheme.value ||
                              Theme.of(context).brightness == Brightness.light
                          ? dark
                          : light,
                    ),
                    subText: Utils().formatPrice(controller.balance.value),
                    subStyle: TextStyle(
                      color: controller.balance.value < 0
                          ? Colors.red
                          : Colors.green,
                    ),
                  ).padding3),
            ],
          ),
        ).card
      ],
    );
  }

  branches(BuildContext context) {
    Get.defaultDialog(
        title: "Select Branch",
        content: Column(
          children: [
            Obx(() => DropDownText2(
                hint: "Select Branch",
                label: "Select Branch",
                controller: controller.selBList,
                isLoading: controller.isB.value,
                validate: true,
                list: controller.bList,
                onChange: (DropDownModel? data) {
                  controller.branch.text = data!.id.toString();
                  controller.selBList = data;
                  controller.branchName.text = data.name;
                }).padding9),
            const Divider(),
            Row(
              children: [
                MButton(
                    onTap: () {
                      if (controller.isInstant.value) {
                        if (controller.branchName.text.isNotEmpty) {
                          controller.sellService().then((value) => printDialog(
                              context, controller.products.keys.toList()));
                        } else {
                          Utils().showError(
                              "Select the branch you are making sales under");
                        }
                      } else if (controller.isBook.value) {
                        if (controller.branchName.text.isNotEmpty) {
                          controller.bookService();
                        } else {
                          Utils().showError(
                              "Select the branch you are making sales under");
                        }
                      } else {
                        Utils().showError(
                            "Select service section, either booking or instant");
                      }
                    },
                    type: ButtonType.save)
              ],
            )
          ],
        ));
  }

  proformalbranches(BuildContext context) {
    Get.defaultDialog(
        title: "Select Branch",
        content: Column(
          children: [
            Obx(() => DropDownText2(
                hint: "Select Branch",
                label: "Select Branch",
                controller: controller.selBList,
                isLoading: controller.isB.value,
                validate: true,
                list: controller.bList,
                onChange: (DropDownModel? data) {
                  controller.branch.text = data!.id.toString();
                  controller.selBList = data;
                  controller.branchName.text = data.name;
                }).padding9),
            const Divider(),
            Row(
              children: [
                MButton(
                    onTap: () {
                      if (controller.branchName.text.isNotEmpty) {
                        controller.bookService().then((value) =>
                            printProformalDialog(
                                context, controller.products.keys.toList()));
                      } else {
                        Utils().showError(
                            "Select the branch you are making sales under");
                      }
                    },
                    type: ButtonType.save)
              ],
            )
          ],
        ));
  }

  printProformalDialog(BuildContext context, List<dynamic> items) {
    Get.defaultDialog(
      title: "Print Preview",
      barrierDismissible: false,
      content: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 600,
              height: 500,
              child: PdfPreview(
                canDebug: false,
                padding: const EdgeInsets.all(.0),
                build: (format) => ProformalReceipt(
                  controller: controller,
                  sd: items,
                  invoiceID: controller.invoiceID,
                  context: context,
                  branch: controller.branchName.text,
                  customer: controller.cus.text,
                  rep: Utils.userName,
                  booking: controller.date.text.toString(),
                  total: Utils().formatPrice(controller.total.value),
                  discount:
                      Utils().formatPrice(controller.discountAmount.value),
                  payable: Utils().formatPrice(controller.payable.value),
                ).generatePdf(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MButton(
              onTap: () {
                controller.clearfield();
                Get.back();
              },
              type: ButtonType.cancel,
            )
          ],
        ),
      ),
    );
  }

  printDialog(BuildContext context, List<dynamic> items) {
    Get.defaultDialog(
      title: "Print Preview",
      barrierDismissible: false,
      content: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 600,
              height: 500,
              child: PdfPreview(
                canDebug: false,
                padding: const EdgeInsets.all(.0),
                build: (format) => SalesReceipt(
                        controller: controller,
                        sd: items,
                        invoiceID: controller.invoiceID,
                        context: context,
                        branch: controller.branchName.text,
                        customer: controller.cus.text,
                        rep: Utils.userName,
                        booking: controller.date.text.toString(),
                        total: Utils().formatPrice(controller.total.value),
                        discount: Utils()
                            .formatPrice(controller.discountAmount.value),
                        payable: Utils().formatPrice(controller.payable.value),
                        payment: Utils().formatPrice(controller.payment.text),
                        balance: Utils().formatPrice(controller.balance.value))
                    .generatePdf(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MButton(
              onTap: () {
                controller.clearfield();
                Get.back();
              },
              type: ButtonType.cancel,
            )
          ],
        ),
      ),
    );
  }
}
