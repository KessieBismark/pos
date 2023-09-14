import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/utils/query.dart';
import '../../../../services/widgets/dropdown.dart';
import '../../../../services/widgets/dropdowntext2.dart';
import '../../../branches/component/controller/controller.dart';
import '../../../customers/component/controller/controller.dart';
import '../../../job_services/entry/component/controller/controller.dart';
import '../../../job_services/entry/component/model.dart';
import '../model.dart';

final cu = Get.find<CustomerCon>();
final s = Get.find<ServiceEntryCon>();
final b = Get.find<BranchesCon>();

class POSCon extends GetxController {
  final salesKey = GlobalKey<FormState>();
  List<LogicalKeyboardKey> keys = [];
  List<CartModel> cart = <CartModel>[].obs;

  List<CartModel> listS = <CartModel>[];
  List<CartModel> list = <CartModel>[];
  List<ServiceModel> ss = <ServiceModel>[];
  List<ServiceModel> serList = <ServiceModel>[];
  List<String> pay = ['Cash', 'POS', 'Mobile Money'];
  final payment = TextEditingController();
  final paymentType = TextEditingController();
  final date = TextEditingController();
  final cus = TextEditingController();
  var setDate = false.obs;
  var loading = false.obs;
  var today = DateTime.now();
  var isCu = false.obs;
  var isSave = false.obs;
  var isService = false.obs;
  var isPrice = false.obs;
  int quantity = 0;
  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;
  var balance = 0.0.obs;
  final formKey = GlobalKey<FormState>();
  final qty = TextEditingController();
  final name = TextEditingController();
  final email = TextEditingController();
  final sales = TextEditingController();
  final contact = TextEditingController();
  final address = TextEditingController();
  final discount = TextEditingController();
  final branchName = TextEditingController();
  final branch = TextEditingController();
  final search = TextEditingController();

  dynamic price = 0.0;
  var total = 0.0.obs;
  var discountAmount = 0.0.obs;
  var payable = 0.0.obs;
  var salesAmount = 0.0.obs;
  var booked = 0.obs;

  var count = 0.obs;
  String customerID = '';
  String serviceID = '';
  String subCat = '';
  dynamic cdiscount;
  String branchID = '';
  String sub = '';
  String bb = '';
  String invoiceID = '';
  String meg = '';
  DropDownModel? selBList;
  CusModel? cusList;
  CartModel? seletedCart;
  SalesModel? selectedItem;
  List<SalesModel> sList = [];
  List<DropDownModel> bList = [];
  List<CusModel> cList = [];
  String deleteID = '';
  String customerPhone = '';
  var totalSum = 0.0.obs;
  var isInstant = true.obs;
  var isBook = false.obs;
  var isB = false.obs;
  final _product = {}.obs;
  var isChange = false.obs;
  var myProduct = {}.obs;

  @override
  void onInit() {
    super.onInit();
    Utils.checkAccess();
    reload();
  }

  reload() {
    date.text = DateFormat.yMMMMd().format(DateTime.now());
    Utils.userRole == 'Super Admin'
        ? getServices(branch.text)
        : getServices(Utils.branchID);
    getCustomer();
    getBranch();
    salesInfo();
  }

  getBranch() {
    isB.value = true;
    b.fetchServiceCategory().then((value) {
      b.cat = [];
      b.cat.addAll(value);
      bList = [];
      for (int i = 0; i < b.cat.length; i++) {
        bList.add(DropDownModel(id: b.cat[i].id, name: b.cat[i].name));
      }
      isB.value = false;
    });
  }

  delete(int index) {
    loading.value = true;
    cart.removeAt(index);
    loading.value = false;
    total.value = 0;
    if (cart.isEmpty) {
      price = 0.0;
      sales.clear();
      sub = '';
    }
    isPrice.value = true;
    isPrice.value = false;
    for (int i = 0; i < cart.length; i++) {
      total.value = total.value + cart[i].price;
    }
    calculateDiscount(total.value);
  }

  getServices(String branch) {
    isService.value = true;
    s.fetchData(branch).then((value) {
      ss = [];
      sList = [];
      serList = [];
      list = [];
      ss.addAll(value);
      serList = ss;
      for (int i = 0; i < ss.length; i++) {
        sList.add(SalesModel(
            id: ss[i].id,
            name: ss[i].name,
            price: double.parse(ss[i].price),
            quantity: int.parse(ss[i].quantity!),
            sub: ss[i].sub));
        list.add(CartModel(
            serviceId: ss[i].id,
            service: ss[i].name,
            sub: ss[i].sub,
            quantity: int.parse(ss[i].quantity!),
            price: ss[i].price,
            cat: ss[i].cat));
      }
      listS = list;
      isService.value = false;
    });
  }

  calculateDiscount(dynamic total) {
    try {
      if (cdiscount != null) {
        if (total != 0) {
          discountAmount.value = (cdiscount / 100) * total;
          payable.value = total - discountAmount.value;
          if (payment.text.isNotEmpty) {
            balance.value =
                double.parse(payment.text.replaceAll(RegExp("\\D"), "")) -
                    payable.value;
          }
        } else {
          payable.value = 0.0;
          discountAmount.value = 0.0;
        }
      }
    } catch (e) {
      print.call(e.toString());
    }
  }

  getCustomer() {
    isCu.value = true;
    cu.fetchServiceCategory().then(
      (value) {
        cu.cc = [];
        cu.cc.addAll(value);
        cList = [];
        for (int i = 0; i < cu.cc.length; i++) {
          cList.add(
            CusModel(
                id: cu.cc[i].id,
                name: cu.cc[i].name,
                discount: int.parse(cu.cc[i].discount),
                contact: cu.cc[i].contact),
          );
        }
        isCu.value = false;
      },
    );
  }

  clearCus() {
    name.clear();
    contact.clear();
    email.clear();
    address.clear();
    discount.clear();
  }

  clearfield() {
    payable.value = 0.0;
    discountAmount.value = 0.0;
    total.value = 0.0;
    balance.value = 0.0;
    price = 0.0;
    payment.clear();
    cart.clear();
    cus.clear();
    cusList = null;
    branchName.clear();
    selectedItem = null;
    selBList = null;
    sales.clear();
    cdiscount = null;
    date.text = DateFormat.yMMMMd().format(DateTime.now());
    loading.value = true;
    loading.value = false;
    isPrice.value = true;
    isPrice.value = false;
    isBook.value = false;
    isService.value = true;
    isCu.value = true;
    isB.value = true;
    isService.value = false;
    isInstant.value = true;
    isB.value = false;
    isCu.value = false;
    _product.clear();
    salesInfo();
  }

  void addProduct(CartModel order) {
    if (_product.containsKey(order)) {
      _product[order] += 1;
    } else {
      _product[order] = 1;
    }
    productQuantity(order);
  }

  void addProductDesk(CartModel order, int quantity) {
    if (_product.containsKey(order)) {
      _product[order] += quantity;
    } else {
      _product[order] = quantity;
    }
    //productQuantity(order);
  }

  productQuantity(CartModel product) {
    return _product[product];
  }

  void deleteItem(CartModel order) {
    if (_product.containsKey(order)) {
      _product.removeWhere((key, value) => key == order);
    }
  }

  void removeProduct(CartModel order) {
    if (_product.containsKey(order) && _product[order] == 1) {
      _product.removeWhere((key, value) => key == order);
    } else {
      _product[order] -= 1;
    }
    productQuantity(order);
  }

  getTotal(List<dynamic> list) {
    total.value = 0.0;
    try {
      for (int i = 0; i < list.length; i++) {
        if (list[i].price.toString().isNotEmpty) {
          if (productQuantity(list[i]) != null) {
            total.value = total.value +
                (double.parse(list[i].price) * productQuantity(list[i]));
          }
        }
      }
    } catch (e) {
      print.call(e.toString());
    }
    calculateDiscount(total.value);
    return total.value.toString();
  }

  get products => _product;

  void addToCart() {
    if (salesKey.currentState!.validate()) {
      if (cus.text.isNotEmpty) {
        if (sub.isNotEmpty && price.toString().isNotEmpty) {
          if (cart.any((element) => element.service == sales.text)) {
            Utils().showError("Item already exist in cart");
          } else {
            loading.value = true;
            cart.add(CartModel(
                service: sales.text,
                sub: sub,
                price: price,
                serviceId: serviceID));
            sales.clear();
            sub = "";
            price = 0.0;
            isService.value = true;
            loading.value = false;
            isService.value = false;
            total.value = 0;
            for (int i = 0; i < cart.length; i++) {
              total.value = total.value + cart[i].price;
            }
            calculateDiscount(total.value);
            if (payment.text.isNotEmpty) {
              balance.value =
                  double.parse(payment.text.replaceAll(RegExp("\\D"), "")) -
                      payable.value;
            }
          }
          selectedItem = null;
          sub = '';
          isPrice.value = true;
          isPrice.value = false;
          isService.value = true;
          isService.value = false;
        } else {
          Utils().showError(
              "Could not get category or price for this service. Select a service");
        }
      } else {
        Utils().showError("Select a customer");
      }
    }
  }

  Future bookService() async {
    if (paymentType.text.isNotEmpty) {
      if (customerID.isNotEmpty) {
        Get.back();
        //  isLoadingDialog();
        try {
          var query = {
            "action": "book_service",
            "customer": customerID.toString(),
            "total": total.value.toString(),
            "payable": payable.value.toString(),
            "discount": discountAmount.value.toString(),
            "rep": Utils.uid.value,
            "bal": balance.value.toString(),
            "payment": payment.text,
            "date": date.text,
            "book": "1",
            "branch": Utils.userRole == "Super Admin"
                ? branch.text
                : Utils.branchID.toString()
          };
          var val = await Query.queryData(query);
          if (jsonDecode(val) != "false") {
            var res = jsonDecode(val);
            invoiceID = res[0]['id'].toString();
            isInstant.value = true;
            saveCart(invoiceID);
          } else {
            Utils().showError(noInternet);
          }
        } catch (e) {
          print(e);
        }
      } else {
        Utils().showError("Select a customer and make sure cart is not empty");
      }
    } else {
      Utils().showError("Select payment type");
    }
  }

  isLoadingDialog() {
    Get.defaultDialog(
        content: const CircularProgressIndicator(
      strokeWidth: 10,
    ));
  }

  Future sellService() async {
    if (paymentType.text.isNotEmpty) {
      if (customerID.isNotEmpty) {
        if (double.parse(payment.text) >= payable.value) {
          Get.back();
          try {
            var query = {
              "action": "sell_service",
              "customer": customerID.toString(),
              "total": total.value.toString(),
              "payable": payable.value.toString(),
              "discount": discountAmount.value.toString(),
              "rep": Utils.uid.value,
              "bal": balance.value.toString(),
              "payment": payment.text,
              "date": date.text,
              "book": isInstant.value ? "0" : "1",
              "branch": Utils.userRole == "Super Admin"
                  ? branch.text
                  : Utils.branchID.toString()
            };
            var val = await Query.queryData(query);
            if (jsonDecode(val) != "false") {
              var res = jsonDecode(val);
              invoiceID = res[0]['id'].toString();
              saveCart(invoiceID);
              isInstant.value = true;
            } else {
              Utils().showError(noInternet);
            }
          } catch (e) {
            print(e);
          }
        } else {
          Utils().showError("Payment should not be less than amount payable");
        }
      } else {
        Utils().showError("Select a customer and make sure cart is not empty");
      }
    } else {
      Utils().showError("Select payment type");
    }
  }

  void salesInfo() async {
    try {
      var data = {"action": "sales_info", "branch": Utils.branchID.toString()};
      var val = await Query.queryData(data);

      if (jsonDecode(val) != 'false') {
        var res = jsonDecode(val);
        salesAmount.value = double.parse(res[0]['sales']);
        count.value = int.parse(res[0]['count']);
        booked.value = int.parse(res[0]['booked']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void saveCart(String id) async {
    try {
      String sql = '';
      List<dynamic> items = products.keys.toList();
      for (int i = 0; i < items.length; i++) {
        sql =
            "INSERT INTO `sales_details`(`service_id`,`sales_id`, `price`,quantity,sub_total) VALUES ('${items[i].serviceId}','$id','${items[i].price}','${productQuantity(items[i])}','${productQuantity(items[i]) * double.parse(items[i].price)}');";
        var query = {"action": "save_cart", "sql": sql};
        var val = await Query.queryData(query);
      }
      if (isBook.value) {
      } else {
        meg =
            "You have made payment for items(s) that amount to ${Utils().formatPrice(payable)} on ${date.text}";
      }
      // Sms().sendSms(customerPhone, meg);
    } catch (e) {
      isBook.value = false;
      print(e);
    }
  }

  void searchService(String text) async {
    try {
      isPrice.value = true;
      var query = {"action": "get_price", "name": text.trim()};
      var val = await Query.login(query);
      if (jsonDecode(val) == "false") {
        isPrice.value = false;
        Utils().showError("Something happened, could not get price");
      } else {
        isPrice.value = false;
        var res = jsonDecode(val);
        serviceID = res[0]['id'].toString();
        price = res[0]['duration_cost'];
        sub = res[0]['sub_category'];
      }
    } catch (e) {
      isPrice.value = false;
      print(e.toString());
    }
  }

  void searchCustomer(String text) async {
    try {
      var query = {"action": "get_customer_details", "name": text.trim()};
      var val = await Query.login(query);
      if (jsonDecode(val) == "false") {
        Utils().showError("Something happened, could not get price");
      } else {
        var res = jsonDecode(val);
        customerID = res[0]['id'].toString();
        cdiscount = double.parse(res[0]['discount']);
        customerPhone = res[0]['contact'];
      }
    } catch (e) {
      print(e.toString());
    }
    isPrice.value = true;
    isPrice.value = false;
  }

  insertCustomer() async {
    if (formKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "add_customer",
          "name": name.text.trim().capitalizeFirst,
          "email": email.text.trim(),
          "contact": contact.text.trim(),
          "address": address.text.trim(),
          "discount": discount.text.trim()
        };
        var val = await Query.queryData(query);
        if (jsonDecode(val) == 'true') {
          isSave.value = false;
          clearCus();
          getCustomer();
          Get.back();
        } else if (jsonDecode(val) == 'duplicate') {
          isSave.value = false;
          Utils().showError(duplicate);
        } else {
          isSave.value = false;
          Utils().showError(notSaved);
        }
      } catch (e) {
        isSave.value = false;
        print.call(e);
      }
    }
  }
}
