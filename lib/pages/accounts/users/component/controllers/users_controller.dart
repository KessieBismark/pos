import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../services/constants/constant.dart';
import '../../../../../services/constants/global.dart';
import '../../../../../services/utils/helpers.dart';
import '../../../../../services/utils/mailer.dart';
import '../../../../../services/utils/query.dart';
import '../../../../../services/utils/sms.dart';
import '../../../../branches/component/controller/controller.dart';
import '../model/users_model.dart';

final b = Get.find<BranchesCon>();

class UsersController extends GetxController {
  final shopFormKey = GlobalKey<FormState>();

  List<UsersModel> users = <UsersModel>[];
  List<UsersModel> usersRecords = <UsersModel>[];
  final email = TextEditingController();
  final name = TextEditingController();
  final contact = TextEditingController();
  final password = TextEditingController();
  final cpassword = TextEditingController();
  final role = TextEditingController();
  var deleting = false.obs;
  var loading = false.obs;
  var getData = false.obs;
  var cRole = false.obs;
  List pass = [' ', 'Sales', 'Manager', 'Super Admin'];
  var permission = [].obs;
  final branch = TextEditingController();
  var isB = false.obs;
  List<String> bList = [];
  var isAdmin = false.obs;

  String userName = '';
  String deleteID = "";
  var genSelected = ' '.obs;
  @override
  void onInit() {
    Utils.checkAccess();
    super.onInit();
    getSmsDetails();
    reload();
  }

  void reload() {
    getData.value = true;
    fetchUsers().then((value) {
      users = [];
      usersRecords = [];
      users.addAll(value);
      usersRecords = users;
      getData.value = false;
    });

    getBranch();
  }

  @override
  void onClose() {
    cleatText();
    reload();
    super.onClose();
  }

  cleatText() {
    name.clear();
    email.clear();
    contact.clear();
    role.clear();
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

  String? validator(String? value) {
    if (value!.isEmpty) {
      return 'Please this field is required';
    }
    return null;
  }

  void setSelected(String value) {
    genSelected.value = value;
    role.text = value;
  }

  void updateUsers(String id) async {
    if (shopFormKey.currentState!.validate()) {
      if (password.text != cpassword.text) {
        Utils().showError("Password do not match!");
      } else {
        loading.value = true;

        try {
          var data = {
            "action": "update_user",
            "id": id,
            "email": email.text,
            "branch": isAdmin.value ? "0" : branch.text,
            "password": Utils.encryptMyData(password.text)
          };
          var val = await Query.queryData(data);
          if (jsonDecode(val) == 'true') {
            loading.value = false;
            cleatText();
            reload();
            Utils().showInfo(saved);
          } else {
            loading.value = false;
            Utils()
                .showError("Something went wrong. Check internet connection");
          }
        } catch (e) {
          loading.value = false;
          print.call(e);
          Utils().showError(noInternet);
        }
      }
    }
  }

  void changeRole(String id) async {
    if (role.text.isEmpty) {
      Utils().showError("Select role");
    } else {
      String access = '';
      if (role.text == "Super Admin") {
        access = Pages().getAllRoles().join(",");
      }
      try {
        cRole.value = true;
        var data = {
          "action": "change_role",
          "id": id,
          "role": role.text,
          "access": access,
        };
        var val = await Query.queryData(data);
        if (jsonDecode(val) == 'true') {
          cRole.value = false;
          reload();
          cleatText();
          Utils().showInfo(saved);
        } else {
          loading.value = false;
          Utils().showError("Something went wrong. Check internet connection");
        }
      } catch (e) {
        cRole.value = false;
        print.call(e);
        Utils().showError(noInternet);
      }
    }
  }

  void delete(String id) async {
    if (id.isNotEmpty) {
      deleteID = id;
      try {
        deleting.value = true;
        var data = {"action": "delete_user", "id": id};
        var val = await Query.queryData(data);
        if (jsonDecode(val) == 'true') {
          reload();
          deleting.value = false;
          Utils().showInfo("Record has been deleted");
        } else if (jsonDecode(val) == 'false') {
          deleting.value = false;
          Utils().showError("Something went wrong, could not delete record");
        } else {
          deleting.value = false;
          Utils().showError(noInternet);
        }
      } catch (e) {
        deleting.value = false;
        print.call(e);
        Utils().showError(noInternet);
      }
    }
  }

  bool isContact(String number) {
    bool check = false;
    if (number.length == 10) {
      check = true;
    } else {
      check = false;
    }
    return check;
  }

  void getSmsDetails() async {
    try {
      var data = {
        "action": "view_api",
      };
      var val = await Query.queryData(data);
      var value = json.decode(val);
      smsAPI = value[0]['api'];
      smsHeader = value[0]['header'];
      print.call(smsAPI);
      print.call(smsHeader);
    } catch (e) {
      print.call(e);
    }
  }

  void insert() async {
    if (shopFormKey.currentState!.validate()) {
      if (!GetUtils.isEmail(email.text)) {
        Utils().showError('Invalid email!');
      } else if (!isContact(contact.text)) {
        Utils().showError("Contact input does not match a phone number");
      } else {
        if (password.text != cpassword.text) {
          Utils().showError("Password do not match!");
        } else if (role.text.isEmpty) {
          Utils().showError("Please select user role");
        } else {
          loading.value = true;
          var myRand = Utils.getRandomNumbers();
          String access = '';
          if (role.text == "Super Admin") {
            access = Pages().getAllRoles().join(",");
          } else {
            access = '';
          }
          try {
            var data = {
              "action": "add_user",
              "email": email.text.trim(),
              "vCode": myRand,
              "code": Utils.encryptMyData(myRand),
              "role": role.text,
              "access": access,
              "contact": contact.text,
              "branch": isAdmin.value ? "0" : branch.text,
            };
            var val = await Query.queryData(data);
            if (jsonDecode(val) == 'true') {
              Sms().sendSms(contact.text,
                  "Welcome, Please visit $appLink or open the application on your desktop, login with your email and this temporary password: $myRand to create a new password");
              String message =
                  "Welcome! Please visit $appLink or open the application on your desktop, login with your email and this temporary password: $myRand to create a new password";
              Mail.sendMail(email.text, "Account Creation", message);
              loading.value = false;
              reload();
              Utils().showInfo(saved);
            } else if (jsonDecode(val) == 'duplicate') {
              loading.value = false;
              Utils().showError("${name.text} already exist in the database");
            } else {
              loading.value = false;
              Utils()
                  .showError("Something went wrong. Check internet connection");
            }
          } catch (e) {
            loading.value = false;
            print.call(e);
            Utils().showError(noInternet);
          }
        }
      }
    }
  }

  Future<List<UsersModel>> fetchUsers() async {
    var shop = <UsersModel>[];
    try {
      var data = {
        "action": "view_users",
      };
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      for (var empJson in empJson) {
        shop.add(UsersModel.fromJson(empJson));
      }
      return shop;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return shop;
    }
  }
}

class Pages {
  final sections = [
    'View Record',
    'Insert Record',
    'Update Record',
    'Delete Record',
    'Print Record'
  ];
  final section2 = [
    'View Record',
    'Insert Record',
    'Update Record',
    'Delete Record',
  ];
  final salesSection = ['View Record', 'Make Sales', 'Make Bookings'];
  final serivces = [
    'Products Category',
    'Products Sub Category',
    'Products Entry',
  ];
  final smsSection = ['View Record', 'Send sms'];

  final sales = [
    'View Record',
    'Pending Sales',
    'sales',
    'sales report',
  ];

  final customer = [
    'customer',
  ];

  final sms = [
    'sms portal',
  ];
  final branches = [
    'Branches',
    'company registration',
  ];
  final cashflow = [
    'cash flow',
  ];

  final income = [
    'income Category',
    'income Sub Category',
    'income Entry',
  ];
  final expenses = [
    'expenses Category',
    'expenses Sub Category',
    'expenses Entry',
  ];

  final company = [
    'company registration',
  ];
  final companySection = ['Insert Record'];

  List<String> role = [];
  String id = '';

  getAllRoles() {
    assign(serivces, section2);
    assign(sales, salesSection);
    assign(customer, section2);
    assign(branches, section2);
    assign(sms, smsSection);
    assign(income, sections);
    assign(cashflow, sections);
    assign(expenses, sections);
    return role;
  }

  void assign(List page, List sections) {
    for (int i = 0; i < page.length; i++) {
      for (int j = 0; j < sections.length; j++) {
        id = initials(page[i], j);
        role.add(id);
      }
    }
  }

  initials(String val, int num) {
    List<String> spliter = val.split(" ");
    String label = '';
    for (int i = 0; i < spliter.length; i++) {
      label = label + spliter[i].trim()[0].toUpperCase();
    }
    label = label + num.toString();
    return label;
  }
}
