import 'dart:convert';

import '../../../customers/component/controller/controller.dart';
import '../../../../services/utils/sms.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/helpers.dart';
import '../model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/utils/query.dart';

final cus = Get.find<CustomerCon>();

class SmsCon extends GetxController {
  final formKey = GlobalKey<FormState>();
  final receiver = TextEditingController();
  final meg = TextEditingController();
  final type = TextEditingController();
  final cn = TextEditingController();
  final api = TextEditingController();
  final header = TextEditingController();
  String allContact = '';
  List<String> tList = ['All customers', 'Individual', 'Outsider'];
  List<String> cList = [];
  List<String> cNames = [];
  List<SmsModel> sms = <SmsModel>[];
  List<SmsModel> smsList = <SmsModel>[];
  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;
  var loading = false.obs;
  var isSave = false.obs;
  var isCustomer = false.obs;

  var all = false.obs;
  var out = false.obs;
  var ind = false.obs;

  @override
  void onInit() {
    super.onInit();
    Utils.checkAccess();
    reload();
  }

  reload() {
    getAllCustomers();
    getData();
    clearText();
    getCustomersNames();
  }

  clearText() {
    receiver.clear();
    meg.clear();
    type.clear();
    ind.value = false;
    cn.clear();
    out.value = false;
    all.value = false;
  }

  getCustomersNames() {
    isCustomer.value = true;
    cus.fetchServiceCategory().then((value) {
      cus.cc = [];
      cus.cc.addAll(value);
      cNames = [];
      for (int i = 0; i < cus.cc.length; i++) {
        if (cus.cc[i].contact!.isNotEmpty) {
          cNames.add(cus.cc[i].name);
        }
      }

      allContact = cList.join(',');
    });
  }

  getAllCustomers() {
    isCustomer.value = true;
    cus.fetchServiceCategory().then((value) {
      cus.cc = [];
      cus.cc.addAll(value);
      cList = [];
      for (int i = 0; i < cus.cc.length; i++) {
        if (cus.cc[i].contact!.isNotEmpty) {
          cList.add(cus.cc[i].contact!);
        }
      }
      allContact = cList.join(',');
    });
  }

  void sendSms() {
    processSms().then((value) {
      insert();
    });
  }

  Future processSms() async {
    if (all.value) {
      isSave.value = true;
      Sms().sendSms(allContact, meg.text.trim());
    } else if (ind.value) {
      isSave.value = true;

      sendInd();
      isSave.value = false;
    } else {
      if (Utils.isNumeric(receiver.text) && (receiver.text.length == 10)) {
        isSave.value = true;

        Sms().sendSms(receiver.text.trim(), meg.text.trim());
        isSave.value = false;
      } else {
        isSave.value = false;
        Utils().showError("Wrong contact entered!");
      }
    }
  }

  sendInd() async {
    try {
      isSave.value = true;
      var query = {
        "action": "send_sms",
        "receiver": cn.text.trim(),
        "meg": meg.text.trim(),
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

  insert() async {
    try {
      isSave.value = true;
      var query = {
        "action": "add_sms",
        "receiver": receiver.text.trim(),
        "meg": meg.text.trim(),
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

  insertAPI() async {
    if (header.text.isNotEmpty && api.text.isNotEmpty) {
      try {
        isSave.value = true;
        var query = {
          "action": "add_api",
          "api": api.text.trim(),
          "header": header.text.trim(),
        };
        var val = await Query.queryData(query);

        if (jsonDecode(val) == 'true') {
          Sms.smsAPI = api.text;
          Sms.smsHeader = header.text;
          isSave.value = false;
          Utils().showInfo("API settings has been saved successfully");
        } else {
          isSave.value = false;
          Utils().showError(notSaved);
        }
      } catch (e) {
        isSave.value = false;
        print.call(e);
      }
    } else {
      Utils().showError("API and header cannot be empty!");
    }
  }

  void smsSettings() {
    getAPI().then((value) {});
  }

  Future getAPI() async {
    try {
      var query = {
        "action": "view_api",
      };
      var val = await Query.queryData(query);

      if (jsonDecode(val) == 'false') {
        Sms.smsAPI = "";
        Sms.smsHeader = "";
        Utils().showInfo("Please set sms API and header");
      } else {
        var res = jsonDecode(val);
        Sms.smsAPI = res[0]['api'];
        Sms.smsHeader = res[0]['header'];
        api.text = res[0]['api'];
        header.text = res[0]['header'];
      }
    } catch (e) {
      isSave.value = false;
      print.call(e);
    }
  }

  getData() {
    loading.value = true;
    fetchData().then((value) {
      sms = [];
      smsList = [];
      sms.addAll(value);
      smsList = sms;
      loading.value = false;
    });
  }

  Future<List<SmsModel>> fetchData() async {
    var record = <SmsModel>[];
    try {
      var data = {
        "action": "view_sms",
      };
      var result = await Query.queryData(data);
      var res = json.decode(result);
      for (var res in res) {
        record.add(SmsModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }
}
