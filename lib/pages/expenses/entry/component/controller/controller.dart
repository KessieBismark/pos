import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../services/constants/constant.dart';
import '../../../../../services/utils/helpers.dart';
import '../../../../../services/utils/query.dart';
import '../../../../branches/component/controller/controller.dart';
import '../../../category/component/controller/controller.dart';
import '../../../sub_category/component/controller/controller.controller.dart';
import '../model.dart';
import '../print_out/receipt.dart';

final su = Get.find<ESCatCon>();
final b = Get.find<BranchesCon>();
final c = Get.find<ECatCon>();

class EEntryCon extends GetxController {
  final eeformKey = GlobalKey<FormState>();
  List<EModel> ss = <EModel>[];
  List<EModel> ssList = <EModel>[];
  List<String> catList = [];
  List<String> suList = [];
  final amount = TextEditingController();
  final date = TextEditingController();
  final des = TextEditingController();
  final chequeNo = TextEditingController();
  final catItem = TextEditingController();
  final sdate = TextEditingController();
  final edate = TextEditingController();
  final subItem = TextEditingController();
  final dateText = TextEditingController();
  final branch = TextEditingController();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  List<String> typeList = ['Cash', 'Cheque', 'Mobile Money'];
  final type = TextEditingController();
  var isSCat = false.obs;
  var loading = false.obs;
  var isSave = false.obs;
  var isCat = false.obs;
  var setDate = false.obs;
  var isCheque = false.obs;
  String dailyDate = "";
  String invoiceID = '';
  String selectedDate = "";
  DateTime today = DateTime.now();
  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;
  String deleteID = '';
  var isDelete = false.obs;
  String catSelected = '';
  String sCatSelected = '';
  dynamic amt = '';
  String chq = '';
  String tp = '';
  String dt = '';
  String sItem = '';
  String dess = '';
  String bn = '';
  var isB = false.obs;
  List<String> bList = [];
  String bb = '';

  @override
  void onInit() {
    super.onInit();
    Utils.checkAccess();
    reload();
  }

  reload() {
    getData();
    getCategories();
    clearText();
    getBranch();
  }

  clearText() {
    des.clear();
    subItem.clear();
    type.clear();
    amount.clear();
    setDate.value = false;
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

  static const menuItems = <String>[
    'Add New',
    'Search',
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

  getBranch() {
    isB.value = true;
    b.fetchServiceCategory().then((value) {
      b.cat = [];
      b.cat.addAll(value);
      bList = [];
      for (int i = 0; i < b.cat.length; i++) {
        bList.add(b.cat[i].name);
      }
      isB.value = false;
    });
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

  insert() async {
    if (eeformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "add_expenses",
          "amount": amount.text.trim(),
          "des": des.text.trim().capitalizeFirst,
          "sub": subItem.text.trim(),
          "cheque_no": chequeNo.text.trim(),
          "type": type.text.trim(),
          "date": dateText.text.trim(),
          "branch": Utils.userRole == "Super Admin"
              ? branch.text.trim()
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
            Get.to(ExpensesReceipt(
                title: "Debit Payment",
                type: type.text,
                branch: bn,
                date: DateTime.parse(dateText.text),
                amount: amount.text,
                des: des.text,
                category: subItem.text,
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

  void getBid(String value) async {
    try {
      var data = {"action": "get_bid", "name": value};
      var val = await Query.login(data);
      if (jsonDecode(val) == 'false') {
        Utils().showError("Could not get branch id");
      } else {
        var res = jsonDecode(val);
        branch.text = res[0]['id'].toString();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getInvoiceID() async {
    try {
      var data = {"action": "get_expenses_invoice"};
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
        "action": "delete_expenses",
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
    if (eeformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "update_expenses",
          "id": id,
          "amount": amount.text.trim(),
          "des": des.text.trim().capitalizeFirst,
          "sub": subItem.text.trim(),
          "cheque_no": chequeNo.text.trim(),
          "type": type.text.trim(),
          "date": dateText.text.trim(),
          "branch": Utils.userRole == "Super Admin"
              ? branch.text.trim()
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

  Future<List<EModel>> searchData() async {
    var record = <EModel>[];
    try {
      var query = {
        "action": "search_expenses",
        "category": catSelected,
        "sub": sCatSelected,
        "sdate": sdate.text,
        "edate": edate.text
      };
      var val = await Query.queryData(query);
      var res = json.decode(val);
      for (var res in res) {
        record.add(EModel.fromJson(res));
      }

      return record;
    } catch (e) {
      print(e);
      return record;
    }
  }

  Future<List<EModel>> fetchData() async {
    var record = <EModel>[];
    try {
      var data = {
        "action": "view_expenses",
      };
      var result = await Query.queryData(data);
      var res = json.decode(result);
      for (var res in res) {
        record.add(EModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }
}
