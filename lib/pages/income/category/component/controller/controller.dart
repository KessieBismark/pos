import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../services/constants/constant.dart';
import '../../../../../services/utils/helpers.dart';
import '../../../../../services/utils/query.dart';
import '../model.dart';

class InCatCon extends GetxController {
  final icformKey = GlobalKey<FormState>();
  List<InCatModel> cat = <InCatModel>[];
  List<InCatModel> catList = <InCatModel>[];
  final name = TextEditingController();
  final des = TextEditingController();
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
    getData();
    clearText();
  }

  clearText() {
    name.clear();
    des.clear();
  }

  getData() {
    loading.value = true;
    fetchServiceCategory().then((value) {
      cat = [];
      catList = [];
      cat.addAll(value);
      catList = cat;
      loading.value = false;
    });
  }

  insert() async {
    if (icformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "add_in_category",
          "name": name.text.trim().capitalizeFirst,
          "des": des.text.trim()
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
        "action": "delete_in_category",
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
    if (icformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "update_in_category",
          "id": id,
          "name": name.text.trim().capitalizeFirst,
          "des": des.text.trim()
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

  Future<List<InCatModel>> fetchServiceCategory() async {
    var record = <InCatModel>[];
    try {
      var data = {
        "action": "view_in_category",
      };
      var result = await Query.queryData(data);
      var res = json.decode(result);
      for (var res in res) {
        record.add(InCatModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }
}
