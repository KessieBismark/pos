import 'dart:convert';

import 'package:get/get.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/utils/query.dart';
import 'model.dart';
import 'package:flutter/material.dart';

class CustomerCon extends GetxController {
  final cuformKey = GlobalKey<FormState>();
  List<CustomerModel> cc = <CustomerModel>[];
  List<CustomerModel> ccList = <CustomerModel>[];
  final name = TextEditingController();
  final email = TextEditingController();
  final contact = TextEditingController();
  final address = TextEditingController();
  final discount = TextEditingController();

  var loading = false.obs;
  var isSave = false.obs;
  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;
  String deleteID = '';
  var isDelete = false.obs;

  @override
  void onInit() {
    super.onInit();
      Utils.checkAccess();
    reload();
  }

  reload() {
    clearText();
    getData();
  }

  clearText() {
    name.clear();
    contact.clear();
    email.clear();
    address.clear();
    discount.clear();
  }

  getData() {
    loading.value = true;
    fetchServiceCategory().then((value) {
      cc = [];
      ccList = [];
      cc.addAll(value);
      ccList = cc;
      loading.value = false;
    });
  }

  insert() async {
    if (cuformKey.currentState!.validate()) {
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

  delete(String id) async {
    try {
      isSave.value = true;
      var query = {
        "action": "delete_customer",
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
    if (cuformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "update_customer",
          "id": id,
          "name": name.text.trim().capitalizeFirst,
          "email": email.text.trim(),
          "contact": contact.text.trim(),
          "address": address.text.trim(),
          "discount": discount.text.trim()
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

 
  Future<List<CustomerModel>> fetchServiceCategory() async {
    var record = <CustomerModel>[];
    try {
      var data = {
        "action": "view_customer",
      };
      var result = await Query.queryData(data);
      var res = json.decode(result);
      for (var res in res) {
        record.add(CustomerModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }
}
