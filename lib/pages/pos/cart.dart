import 'component/printing/print_class.dart';
import '../../services/constants/color.dart';
import 'package:printing/printing.dart';

import '../../services/constants/constant.dart';
import '../../services/widgets/button.dart';
import '../../services/widgets/dropdown.dart';
import 'component/controller/controller.dart';
import 'component/model.dart';
import '../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/utils/helpers.dart';

//final POSCon order = Get.find();

class Cart extends StatelessWidget {
  final String customer;
  final POSCon order;
  const Cart({
    super.key,
    required this.customer,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            "Cart List for ${Utils.userNameinitials(customer).toString().capitalizeFirst}"
                .toAutoLabel(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => Expanded(
                child: ListView.builder(
                  itemCount: order.products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CartProductCart(
                      controller: order,
                      product: order.products.keys.toList()[index],
                      quantity: order.products.values.toList()[index],
                      index: index,
                      cartList: order.products.keys.toList(),
                    );
                  },
                ),
              ),
            ),
            Obx(
              () => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Total: ".toAutoLabel(bold: true),
                      Utils()
                          .formatPrice(order.total.value)
                          .toLabel(bold: true, color: greenfade)
                    ],
                  ).hMargin9,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Discount: ".toLabel(bold: true),
                      Utils()
                          .formatPrice(order.discountAmount.value)
                          .toLabel(bold: true, color: greenfade)
                    ],
                  ).hMargin9,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Payable: ".toAutoLabel(bold: true),
                      Utils()
                          .formatPrice(order.payable.value)
                          .toLabel(bold: true, color: greenfade)
                    ],
                  ).hMargin9,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Payment: ".toAutoLabel(bold: true),
                      SizedBox(
                        height: 20,
                        width: 100,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.end,
                          controller: order.payment,
                          onChanged: (val) {
                            if (val.isNotEmpty) {
                              if (Utils.isNumeric(val)) {
                                order.balance.value =
                                    double.parse(val) - order.payable.value;
                              } else {
                                order.payment.text =
                                    val.replaceAll(RegExp("\\D"), "");
                                Utils().showError(
                                    "Payment amount must not contain a letter");
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ).hMargin9,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Balance: ".toAutoLabel(bold: true),
                      Utils().formatPrice(order.balance.value).toLabel(
                            bold: true,
                            color: order.balance.value < 0
                                ? Colors.red
                                : Colors.green,
                          ),
                    ],
                  ).hMargin9,
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (Utils.access.contains(Utils.initials("sales", 3)) ||
                          Utils.userRole == "Super Admin")
                        ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.deepOrangeAccent)),
                            onPressed: () {
                              if (order.products.isNotEmpty) {
                                Utils.userRole == "Super Admin"
                                    ? proformalbranches(context)
                                    : order.bookService().then((value) =>
                                        printDialog(context,
                                            order.products.keys.toList()));
                              } else {
                                Utils().showError("Cart is empty");
                              }
                            },
                            icon: const Icon(Icons.book_outlined),
                            label: "Proforma/Save".toLabel()),
                      if (Utils.access.contains(Utils.initials("sales", 2)) ||
                          Utils.userRole == "Super Admin")
                        Obx(() => ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 29, 109, 31))),
                            onPressed: order.isBook.value
                                ? null
                                : () {
                                    if (order.payment.text.isNotEmpty) {
                                      if (order.paymentType.text.isNotEmpty) {
                                        if (order.products.isNotEmpty) {
                                          if ((double.parse(
                                                      order.payment.text) -
                                                  (order.payable.value) >=
                                              0)) {
                                            Utils.userRole == "Super Admin"
                                                ? branches(context)
                                                : order.sellService().then(
                                                    (value) => printDialog(
                                                        context,
                                                        order.products.keys
                                                            .toList()));
                                          } else {
                                            Utils().showError(
                                                "Payment is less than amount payable");
                                          }
                                        } else {
                                          Utils().showError("Cart is empty");
                                        }
                                      } else {
                                        Utils()
                                            .showError("Select payment method");
                                      }
                                    } else {
                                      Utils().showError(
                                          "You must enter the amount given to you by the customer");
                                    }
                                  },
                            icon: const Icon(Icons.money_rounded),
                            label: "Make Sales".toLabel()))
                    ],
                  ).hMargin9,
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
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
                controller: order.selBList,
                isLoading: order.isB.value,
                validate:true,
                list: order.bList,
                onChange: (DropDownModel? data) {
                  order.branch.text = data!.id.toString();
                  order.selBList = data;
                  order.branchName.text = data.name;
                }).padding9),
            const Divider(),
            Row(
              children: [
                MButton(
                    onTap: () {
                      if (order.isInstant.value) {
                        if (order.branchName.text.isNotEmpty) {
                          order.sellService().then((value) => printDialog(
                              context, order.products.keys.toList()));
                        } else {
                          Utils().showError(
                              "Select the branch you are making sales under");
                        }
                      } else if (order.isBook.value) {
                        if (order.branchName.text.isNotEmpty) {
                          order.bookService();
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
                controller: order.selBList,
                isLoading: order.isB.value,
                validate:true,
                list: order.bList,
                onChange: (DropDownModel? data) {
                  order.branch.text = data!.id.toString();
                  order.selBList = data;
                  order.branchName.text = data.name;
                }).padding9),
            const Divider(),
            Row(
              children: [
                MButton(
                    onTap: () {
                      if (order.branchName.text.isNotEmpty) {
                        order.bookService().then((value) =>
                            printProformalDialog(
                                context, order.products.keys.toList()));
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
              height: myHeight(context,2),
              child: PdfPreview(
                canDebug: false,
                padding: const EdgeInsets.all(.0),
                build: (format) => ProformalReceipt(
                  controller: order,
                  sd: items,
                  invoiceID: order.invoiceID,
                  context: context,
                  branch: order.branchName.text,
                  customer: order.cus.text,
                  rep: Utils.userName,
                  booking: order.date.text.toString(),
                  total: Utils().formatPrice(order.total.value),
                  discount: Utils().formatPrice(order.discountAmount.value),
                  payable: Utils().formatPrice(order.payable.value),
                ).generatePdf(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MButton(
              onTap: () {
                order.clearfield();
                Get.back();
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
              height: myHeight(context,2.5),
              child: PdfPreview(
                canDebug: false,
                padding: const EdgeInsets.all(.0),
                build: (format) => SalesReceipt(
                        controller: order,
                        sd: items,
                        invoiceID: order.invoiceID,
                        context: context,
                        branch: order.branchName.text,
                        customer: order.cus.text,
                        rep: Utils.userName,
                        booking: order.date.text.toString(),
                        total: Utils().formatPrice(order.total.value),
                        discount:
                            Utils().formatPrice(order.discountAmount.value),
                        payable: Utils().formatPrice(order.payable.value),
                        payment: Utils().formatPrice(order.payment.text),
                        balance: Utils().formatPrice(order.balance.value))
                    .generatePdf(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MButton(
              onTap: () {
                order.clearfield();
                Get.back();
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

class CartProductCart extends StatelessWidget {
  const CartProductCart({
    Key? key,
    required this.controller,
    required this.product,
    required this.quantity,
    required this.index,
    this.cartList,
  }) : super(key: key);

  final POSCon controller;
  final dynamic cartList;
  final dynamic index;
  final CartModel product;
  final dynamic quantity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              product.service.toAutoLabel(bold: true),
              "Sub category: ${product.sub}".toAutoLabel(),
              "Sub Total: ${Utils().formatPrice((double.parse(product.price) * quantity))}"
                  .toAutoLabel(bold: true)
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle),
          onPressed: () {
            controller.addProduct(product);
            controller.getTotal(cartList);
          },
        ),
        quantity.toString().toAutoLabel(),
        IconButton(
          icon: const Icon(Icons.remove_circle),
          onPressed: () {
            controller.removeProduct(product);
            controller.getTotal(cartList);
          },
        ),
      ],
    ).padding9.card;
  }
}
