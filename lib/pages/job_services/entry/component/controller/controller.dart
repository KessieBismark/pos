import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../services/constants/constant.dart';
import '../../../../../services/utils/helpers.dart';
import '../../../../../services/utils/query.dart';
import '../../../../../services/widgets/dropdown.dart';
import '../../../../branches/component/controller/controller.dart';
import '../../../sub_category/component/controller/controller.controller.dart';
import '../model.dart';

final su = Get.find<SSCatCon>();
final b = Get.find<BranchesCon>();

class ServiceEntryCon extends GetxController {
  final seformKey = GlobalKey<FormState>();
  List<ServiceModel> s = <ServiceModel>[];
  List<ServiceModel> sList = <ServiceModel>[];
  List<String> subList = [];
  List<DropDownModel> bList = [];
  DropDownModel? selBList;
  final name = TextEditingController();
  final quantity = TextEditingController();
  final des = TextEditingController();
  final price = TextEditingController();
  final cost = TextEditingController();
  final subItem = TextEditingController();
  //final branch = TextEditingController();
  DropDownModel? branch;
  final branchID = TextEditingController();
  var loading = false.obs;
  var isSave = false.obs;
  var isCat = false.obs;
  var isB = false.obs;
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
    Utils.userRole != 'Super Admin'
        ? getData(branch!.id)
        : getData(Utils.branchID);
    getBranch();
    clearText();
  }

  clearText() {
    name.clear();
    quantity.clear();
    price.clear();
    subItem.clear();
    cost.clear();
    des.clear();
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

  getData(String branch) {
    loading.value = true;
    fetchData(branch).then((value) {
      s = [];
      sList = [];
      s.addAll(value);
      sList = s;
      loading.value = false;
    });
  }

  insert() async {
    if (seformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "add_service",
          "name": name.text.trim().capitalizeFirst,
          "des": des.text.trim(),
          "quantity": quantity.text.trim(),
          "cost": cost.text.trim(),
          "price": price.text.trim(),
          "sub": subItem.text,
          "branch":
              Utils.userRole == 'Super Admin' ? branch!.id : Utils.branchID
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
        "action": "delete_service",
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
    if (seformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "update_service",
          "id": id,
          "name": name.text.trim().capitalizeFirst,
          "des": des.text.trim(),
          "quantity": quantity.text.trim(),
          "cost": cost.text.trim(),
          "price": price.text.trim(),
          "sub": subItem.text,
          "branch":
              Utils.userRole == 'Super Admin' ? branch!.id : Utils.branchID
        };
        print(query);
        var val = await Query.queryData(query);
        print(val);
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
    su.fetchServiceCategory().then((value) {
      su.ss = [];
      su.ss.addAll(value);
      subList = [];
      for (int i = 0; i < su.ss.length; i++) {
        subList.add(su.ss[i].name);
      }
      isCat.value = false;
    });
  }

  Future<List<ServiceModel>> fetchData(String branch) async {
    var record = <ServiceModel>[];
    try {
      var data = {
        "action": "view_service",
        "branch": Utils.userRole == 'Super Admin' ? branch : Utils.branchID
      };
      var result = await Query.queryData(data);
      print(result);
      var res = json.decode(result);
      for (var res in res) {
        record.add(ServiceModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }
}
