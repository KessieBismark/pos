import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../services/constants/constant.dart';
import '../../../../../services/utils/helpers.dart';
import '../../../../../services/utils/query.dart';
import '../../../category/component/controller/controller.dart';
import '../model.dart';

final cat = Get.put(ServiceCatCon());

class SSCatCon extends GetxController {
  final ssformKey = GlobalKey<FormState>();
  List<SSCatModel> ss = <SSCatModel>[];
  List<SSCatModel> ssList = <SSCatModel>[];
  List<String> catList = [];
  final name = TextEditingController();
  final catItem = TextEditingController();
  var loading = false.obs;
  var isSave = false.obs;
  var isCat = false.obs;

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
    getCategories();
    getData();
    clearText();
  }

  getData() {
    loading.value = true;
    fetchServiceCategory().then((value) {
      ss = [];
      ssList = [];
      ss.addAll(value);
      ssList = ss;
      loading.value = false;
    });
  }

  clearText() {
    name.clear();
    catItem.clear();
  }

  insert() async {
    if (ssformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "add_sub_category",
          "name": name.text.trim().capitalizeFirst,
          "sub": catItem.text.trim()
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
        "action": "delete_sub_category",
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
    if (ssformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "update_sub_category",
          "id": id,
          "name": name.text.trim().capitalizeFirst,
          "sub": catItem.text.trim()
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
    cat.fetchServiceCategory().then((value) {
      cat.cat = [];
      cat.cat.addAll(value);
      catList = [];
      for (int i = 0; i < cat.cat.length; i++) {
        catList.add(cat.cat[i].name);
      }
      isCat.value = false;
    });
  }

  Future<List<SSCatModel>> fetchServiceCategory() async {
    var record = <SSCatModel>[];
    try {
      var data = {
        "action": "view_sub_category",
      };
      var result = await Query.queryData(data);
      var res = json.decode(result);
      for (var res in res) {
        record.add(SSCatModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }
}
