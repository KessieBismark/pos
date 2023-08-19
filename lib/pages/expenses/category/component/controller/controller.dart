import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../services/constants/constant.dart';
import '../../../../../services/utils/helpers.dart';
import '../../../../../services/utils/query.dart';
import '../model.dart';

class ECatCon extends GetxController {
  final ecformKey = GlobalKey<FormState>();
  List<ECatModel> cat = <ECatModel>[];
  List<ECatModel> catList = <ECatModel>[];
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
    if (ecformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "add_exp_category",
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
        "action": "delete_exp_category",
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
    des.clear();
  }

  updateData(String id) async {
    if (ecformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "update_exp_category",
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

  Future<List<ECatModel>> fetchServiceCategory() async {
    var record = <ECatModel>[];
    try {
      var data = {
        "action": "view_exp_category",
      };
      var result = await Query.queryData(data);
      var res = json.decode(result);
      for (var res in res) {
        record.add(ECatModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }
}
