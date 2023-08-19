import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/utils/query.dart';
import '../model.dart';

class BranchesCon extends GetxController {
  final bformKey = GlobalKey<FormState>();
  List<BranchModel> cat = <BranchModel>[];
  List<BranchModel> catList = <BranchModel>[];
  final name = TextEditingController();
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
    if (bformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "add_branches",
          "name": name.text.trim().capitalizeFirst,
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
        "action": "delete_branches",
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

  clearText() {
    name.clear();
  }

  updateData(String id) async {
    if (bformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "update_branches",
          "id": id,
          "name": name.text.trim().capitalizeFirst,
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

  Future<List<BranchModel>> fetchServiceCategory() async {
    var record = <BranchModel>[];
    try {
      var data = {
        "action": "view_branches",
      };
      var result = await Query.queryData(data);
      var res = json.decode(result);
      for (var res in res) {
        record.add(BranchModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }
}
