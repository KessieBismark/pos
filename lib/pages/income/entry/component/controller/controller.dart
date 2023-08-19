import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../services/constants/constant.dart';
import '../../../../../services/utils/helpers.dart';
import '../../../../../services/utils/query.dart';
import '../../../../../services/widgets/dropdown.dart';
import '../../../../branches/component/controller/controller.dart';
import '../../../category/component/controller/controller.dart';
import '../../../sub_category/component/controller/controller.controller.dart';
import '../model.dart';
import '../print_out/receipt.dart';

final su = Get.find<InSCatCon>();
final b = Get.find<BranchesCon>();
final c = Get.find<InCatCon>();

class InEntryCon extends GetxController {
  final ieformKey = GlobalKey<FormState>();
  List<InModel> ss = <InModel>[];
  List<CloseSales> closeList = <CloseSales>[];
  List<InModel> ssList = <InModel>[];
  List<String> suList = [];
  List<String> catList = [];
  var isSCat = false.obs;
  final amount = TextEditingController();
  final date = TextEditingController();
  final des = TextEditingController();
  final chequeNo = TextEditingController();
  final subItem = TextEditingController();
  final catItem = TextEditingController();
  final type = TextEditingController();
  final sdate = TextEditingController();
  final edate = TextEditingController();
  final dateText = TextEditingController();
  //final branch = TextEditingController();
  DropDownModel? branch;
  final closeSales = TextEditingController();
  List<String> salesPending = [];
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List<String> typeList = ['Cash', 'Cheque', 'Mobile Money'];
  var loading = false.obs;
  var isSave = false.obs;
  var isCat = false.obs;
  var isCloseSale = false.obs;
  var setDate = false.obs;
  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;
  String deleteID = '';
  String selectedDate = "";
  String invoiceID = '';
  String catSelected = '';
  String sCatSelected = '';

  dynamic amt = '';
  String chq = '';
  String tp = '';
  String dt = '';
  String sItem = '';
  String dess = '';
  String bn = '';
  String bb = '';

  var isDelete = false.obs;
  var isCheque = false.obs;
  String dailyDate = "";
  DateTime today = DateTime.now();
  final DateTime now = DateTime.now();
  var isB = false.obs;
  List<DropDownModel> bList = [];

  @override
  void onInit() {
    super.onInit();
    Utils.checkAccess();
    reload();
  }

  reload() {
    getData();
    getCategories();
    getBranch();
    clearText();
  }

  getBranch() {
    isB.value = true;
    b.fetchServiceCategory().then((value) {
      b.cat = [];
      b.cat.addAll(value);
      bList = [];
      bList.add(DropDownModel(id: '0', name: 'All'));
      for (int i = 0; i < b.cat.length; i++) {
        bList.add(DropDownModel(id: b.cat[i].id, name: b.cat[i].name));
      }
      isB.value = false;
    });
  }

  clearText() {
    des.clear();
    subItem.clear();
    type.clear();
    amount.clear();
    setDate.value = false;
  }

  getData() {
    loading.value = true;
    fetchData().then((value) {
      ss = [];
      ssList = [];
      ss.addAll(value);
      ssList = ss;
      loading.value = false;
    });
  }

  static const menuItems = <String>[
    'Add New',
    'Search',
    'Close Sales',
    'Refresh',
    'Print',
  ];
  final List<PopupMenuItem<String>> popUpMenuItems = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  // void getBid(String value) async {
  //   try {
  //     var data = {"action": "get_bid", "name": value};
  //     var val = await Query.login(data);
  //     if (jsonDecode(val) == 'false') {
  //       Utils().showError("Could not get branch id");
  //     } else {
  //       var res = jsonDecode(val);
  //       branch.id = res[0]['id'].toString();
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  insert() async {
    if (ieformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "add_income",
          "amount": amount.text.trim(),
          "des": des.text.trim().capitalizeFirst,
          "sub": subItem.text.trim(),
          "cheque_no": chequeNo.text.trim(),
          "type": type.text.trim(),
          "date": dateText.text.trim(),
          "branch": Utils.userRole == "Super Admin"
              ? branch!.id.trim()
              : Utils.branchID
        };
        var val = await Query.queryData(query);
        if (jsonDecode(val) == 'true') {
          tp = type.text;
          amt = amount.text;
          dt = dateText.text;
          sItem = subItem.text;
          dess = des.text;
          chq = chequeNo.text;
          bn = bb;

          isSave.value = false;
          getInvoiceID().then((value) {
            Get.to(IncomeReceipt(
                title: "Credit deposit",
                type: tp,
                branch: bn,
                date: DateTime.parse(dt),
                amount: amt,
                des: dess,
                category: sItem,
                invoice: invoiceID));
          });
          reload();
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

  Future getInvoiceID() async {
    try {
      var data = {"action": "get_income_invoice"};
      var res = await Query.login(data);
      if (jsonDecode(res) == "false") {
        Utils().showError(notSaved);
      } else {
        var result = jsonDecode(res);
        invoiceID = result[0]['id'].toString();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  delete(String id) async {
    try {
      isSave.value = true;
      var query = {
        "action": "delete_income",
        "id": id,
      };
      var val = await Query.queryData(query);
      if (jsonDecode(val) == 'true') {
        isSave.value = false;
        reload();
      } else {
        isSave.value = false;
        Utils().showError(notSaved);
      }
    } catch (e) {
      isSave.value = false;
      print.call(e);
    }
  }

  updateData(String id) async {
    if (ieformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "update_income",
          "id": id,
          "amount": amount.text.trim(),
          "des": des.text.trim().capitalizeFirst,
          "sub": subItem.text.trim(),
          "cheque_no": chequeNo.text.trim(),
          "type": type.text.trim(),
          "date": dateText.text.trim(),
          "branch": Utils.userRole == "Super Admin"
              ? branch!.id.trim()
              : Utils.branchID
        };
        var val = await Query.queryData(query);
        if (jsonDecode(val) == 'true') {
          isSave.value = false;
          reload();
          Get.back();
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

  getCategories() {
    isCat.value = true;
    c.fetchServiceCategory().then((value) {
      c.cat = [];
      c.cat.addAll(value);
      catList = [];
      catList.add("All");
      for (int i = 0; i < c.cat.length; i++) {
        catList.add(c.cat[i].name);
      }
      isCat.value = false;
    });
  }

  getSubCategories(String category) {
    isSCat.value = true;
    su.fetchSCategory(category).then((value) {
      su.ss = [];
      su.ss.addAll(value);
      suList = [];
      suList.add("All");
      for (int i = 0; i < su.ss.length; i++) {
        suList.add(su.ss[i].name);
      }
      isSCat.value = false;
    });
  }

  getCloseSales(String branch) {
    isCloseSale.value = true;
    fetchCloseSales(branch).then((value) {
      closeList = [];
      closeList.addAll(value);
      salesPending = [];
      for (int i = 0; i < closeList.length; i++) {
        salesPending.add(
            "${Utils.myMonth(int.parse(closeList[i].month))} ${closeList[i].year}");
      }
      isCloseSale.value = false;
    });
  }

  getSearchData() {
    loading.value = true;
    searchData().then((value) {
      ss = [];
      ssList = [];
      ss.addAll(value);
      ssList = ss;
      loading.value = false;
    });
  }

  calculateSales() async {
    if (closeSales.text.isNotEmpty) {
      try {
        isSave.value = true;
        var spliter = [];
        spliter = closeSales.text.split(" ");
        String year = spliter[1].toString().trim();
        String month = Utils.myMonthNumber(spliter[0]).toString().trim();
        var data = {
          "action": "calculate_sales",
          "year": year,
          "month": month,
          "branch": branch!.id
        };
        var val = await Query.queryData(data);
        if (jsonDecode(val) == 'true') {
          closeSales.clear();
          closeList.clear();
          isCloseSale.value = true;
          isCloseSale.value = false;

          reload();
          isSave.value = false;
          Get.back();
        } else {
          isSave.value = false;
          Utils().showError(notSaved);
        }
      } catch (e) {
        isSave.value = false;
        print.call(e);
      }
    } else {
      Utils().showError(
          "You must select a branch and then select Select month and year ");
    }
  }

  Future<List<InModel>> searchData() async {
    var record = <InModel>[];
    try {
      var query = {
        "action": "search_income",
        "category": catSelected,
        "sub": sCatSelected,
        "sdate": sdate.text,
        "edate": edate.text
      };
      var val = await Query.queryData(query);
      var res = json.decode(val);
      for (var res in res) {
        record.add(InModel.fromJson(res));
      }

      return record;
    } catch (e) {
      print(e);
      return record;
    }
  }

  Future<List<InModel>> fetchData() async {
    var record = <InModel>[];
    try {
      var data = {
        "action": "view_income",
      };
      var result = await Query.queryData(data);
      print(result);
      var res = json.decode(result);
      for (var res in res) {
        record.add(InModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }

  Future<List<CloseSales>> fetchCloseSales(String branch) async {
    var record = <CloseSales>[];
    try {
      var data = {"action": "close_sales", "branch": branch};
      var result = await Query.queryData(data);
      var res = json.decode(result);
      print(result);
      for (var res in res) {
        record.add(CloseSales.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }
}
