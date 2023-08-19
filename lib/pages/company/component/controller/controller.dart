import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/utils/query.dart';

class CompanyCon extends GetxController {
  final cformKey = GlobalKey<FormState>();
  final cname = TextEditingController();
  final contact = TextEditingController();
  final address = TextEditingController();
  final gps = TextEditingController();
  final slogan = TextEditingController();
  final website = TextEditingController();
  final email = TextEditingController();
  List<LogicalKeyboardKey> keys = [];

  var isSave = false.obs;

  insert() async {
    if (cformKey.currentState!.validate()) {
      try {
        isSave.value = true;
        var query = {
          "action": "add_company",
          "name": cname.text.trim(),
          "contact": contact.text.trim(),
          "gps": gps.text.trim(),
          "slogan": slogan.text.trim(),
          "address": address.text.trim(),
          "website": website.text.trim(),
          "email": email.text.trim(),
        };
        var val = await Query.queryData(query);

        if (jsonDecode(val) == 'true') {
          isSave.value = false;
          Get.toNamed('/auth');
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
