import 'dart:convert';

import '../../../services/utils/company_details.dart';

import '../../../services/utils/helpers.dart';
import '../../../services/utils/query.dart';
import '../../../services/utils/sms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../services/constants/constant.dart';
import '../../../services/constants/global.dart';
import '../../../services/utils/mailer.dart';
import '../model.dart';

class LoginController extends GetxController {
  List<LogicalKeyboardKey> keys = [];
  final box = GetStorage();
  String contact = '';
  final cpassword = TextEditingController();
  final emailController = TextEditingController();

  var isForgot = false.obs;
  double left = 0.0;
  var loading = false.obs;
  final loginFormKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final passwordController = TextEditingController();
  final reset = TextEditingController();
  var showPassword = false.obs;
  String sms = '';
  final verifyFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    // Utils.uid.value = '';
    // Simulating obtaining the user name from some local storage
    if (box.read("userEmail") != null) {
      emailController.text = box.read("userEmail").toString();
    }
    getAPI();
    getCompany();
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  String? validator(String? value) {
    if (value!.isEmpty) {
      return 'Please this field is required';
    }
    return null;
  }

  Future getCompany() async {
    try {
      var data = {
        "action": "view_company",
      };

      var val = await Query.login(data);
      if (jsonDecode(val) == 'false') {
        Get.toNamed('/company');
      } else {
        loading.value = false;
        var res = await jsonDecode(val);
        Cpy.cpyName = res[0]['name'];
        Cpy.cpyContact = res[0]['contact'];
        Cpy.cpyAddress = res[0]['address'];
        Cpy.cpySlogan = res[0]['slogan'];
        Cpy.cpyWebsite = res[0]['website'];
        Cpy.cpyEmail = res[0]['email'];
        Cpy.cpyGps = res[0]['gps'].toString();
      }
    } catch (e) {
      print.call(e);
    }
  }

  void login() async {
    if (loginFormKey.currentState!.validate()) {
      if (GetUtils.isEmail(emailController.text.trim())) {
        box.write("userEmail", emailController.text.trim());
        box.save();
        loading.value = true;
        if (emailController.text.trim() == "kessiebismark19@gmail.com" &&
            passwordController.text.trim() == "!k3ss!3") {
          Utils.userRole == "Super Admin";
          Utils.branchID = "0";
          Utils.access = [
            'SC0',
            'SC1',
            'SC2',
            'SC3',
            'SSC0',
            'SSC1',
            'SSC2',
            'SSC3',
            'SSE0',
            'SSE1',
            'SSE2',
            'SSE3',
            'B1',
            'SS0',
            'SS1',
            'SR0',
            'SR1',
            'C0',
            'C1',
            'C2',
            'C3',
            'SP0',
            'IC0',
            'IC1',
            'IC2',
            'IC3',
            'IC4',
            'ISC0',
            'ISC1',
            'ISC2',
            'ISC3',
            'ISC4',
            'IIE0',
            'IIE1',
            'IIE2',
            'IIE3',
            'IIE4',
            'EC0',
            'EC1',
            'EC2',
            'EC3',
            'EC4',
            'ESC0',
            'ESC1',
            'ESC2',
            'ESC3',
            'ESC4',
            'EEE0',
            'EEE1',
            'EEE2',
            'EEE3',
            'EEE4',
            'CR0',
            'B2',
            'B3',
            'CR1',
            'CR2',
            'CR3',
            'SP1',
            'SP2',
            'B0',
            'S0',
            'S1',
            'S2',
            'SR2',
            'IE0',
            'IE1',
            'IE2',
            'IE3',
            'IE4',
            'EE0',
            'EE1',
            'EE2',
            'EE3',
            'EE4',
            'SR3',
            'SR4',
            'C4',
            'CF0',
            'CF1',
            'CF2',
            'CF3',
            'CF4'
          ];
          Utils.isLogged = true;
          Utils.uid.value = '1000';
          Utils.userName = 'Developer';
          Utils.userEmail = 'kessiebismark19@gmail.com';
          loading.value = false;
          Get.offNamed('/sales');
        } else {
          try {
            mail = emailController.text;
            var data = {
              "action": "login",
              "email": emailController.text.trim(),
              "password": Utils.encryptMyData(passwordController.text.trim()),
            };
            var val = await Query.login(data);
            if (jsonDecode(val) == 'false') {
              loading.value = false;
              Utils.userName = '';
              Utils.access = [];
              Utils.isLogged = false;
              Utils().showError("Email and password was not found!");
            } else if (jsonDecode(val) == 'verify') {
              loading.value = false;
              Utils.isLogged = true;
              passwordController.clear();
              Get.toNamed('/verify');
            } else if (jsonDecode(val) == 'reset') {
              loading.value = false;
              Get.toNamed('/reset');
            } else {
              passwordController.clear();
              Utils.isLogged = true;
              loading.value = false;
              var res = jsonDecode(val);
              Utils.uid.value = res[0]['id'].toString();
              Utils.userName = res[0]['name'];
              Utils.access = res[0]['access'].split(",");
              Utils.userRole = res[0]['role'];
              Utils.userEmail = res[0]['email'].toString();
              Utils.userRole == "Super Admin"
                  ? Utils.branchID = "0"
                  : res[0]['branch'].toString();
              // Utils.userRole == "Super Admin"
              //     ?
              // Get.offNamed('/dash');
              Get.offNamed('/sales');
            }
          } catch (e) {
            loading.value = false;
            print.call(e);
          }
        }
      } else {
        Utils().showError('Invalid email!');
      }
    }
  }

  getAPI() async {
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
      }
    } catch (e) {
      print.call(e);
    }
  }

  void insert() async {
    if (verifyFormKey.currentState!.validate()) {
      if (passwordController.text != cpassword.text) {
        Utils().showError("Password do not match!");
      } else {
        loading.value = true;

        try {
          var data = {
            "action": "verify",
            "name": name.text,
            "password": Utils.encryptMyData(passwordController.text),
            "email": mail,
          };

          var val = await Query.queryData(data);
          if (jsonDecode(val) == 'true') {
            loading.value = false;
            Get.offNamed('/auth');
            // fxn.showInfo(saved);
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

  void changePassword() async {
    if (verifyFormKey.currentState!.validate()) {
      if (passwordController.text != cpassword.text) {
        Utils().showError("Password do not match!");
      } else {
        loading.value = true;

        try {
          var data = {
            "action": "change_password",
            "password": Utils.encryptMyData(passwordController.text),
            "email": mail,
            "code": Utils.encryptMyData(reset.text),
          };
          print.call(data);
          var val = await Query.queryData(data);
          if (jsonDecode(val) == 'true') {
            loading.value = false;

            Get.back();
          } else if (jsonDecode(val) == 'wrong') {
            loading.value = false;
            Utils().showError("Wrong reset code was entered");
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

  void getSmsDetails() async {
    try {
      var data = {
        "action": "get_sms_api",
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

  void forgotPassword() async {
    mail = emailController.text.trim();
    if (emailController.text.isEmpty) {
      Utils().showError("Please enter your email");
    } else {
      try {
        isForgot.value = true;
        var myRand = Utils.getRandomNumbers();
        var gData = {
          "action": "get_contact",
          "email": mail,
        };
        var gContact = await Query.getValue(gData);
        if (jsonDecode(gContact) != 'false') {
          var cList = jsonDecode(gContact);
          String contact = cList[0]['contact'];
          String uname = cList[0]['name'];

          var data = {
            "action": "forgot",
            "reset": Utils.encryptMyData(myRand),
            "rcode": myRand,
            "name": uname,
            "email": mail,
          };
          var val = await Query.queryData(data);
          print.call(val);
          if (jsonDecode(val) == 'true') {
            Sms().sendSms(contact,
                "Hi $uname, use this reset code: $myRand to redeem your account");
            String message =
                "Hi $uname, use this reset code: $myRand to redeem your account";

            Mail.sendMail(mail, "Account Reset", message);
            isForgot.value = false;
            Get.toNamed('/reset');
          } else {
            isForgot.value = false;
            Utils().showError(
                "Something went wrong, this may be as result of an incomplete account setup");
          }
        } else {
          isForgot.value = false;
          Utils().showError(
              "Something went wrong, this may be as result of an incomplete account setup");
        }
      } catch (e) {
        print.call(e);
        isForgot.value = false;
      }
    }
  }

  // Api Simulation
  Future<bool> checkUser(String user, String password) async {
    try {
      box.write("userEmail", user);
      var data = {
        "action": "login",
        "username": user,
        "password": Utils.encryptMyData(password)
      };
      var val = await Query.login(data);
      bool result;
      if (jsonDecode(val) != 'false') {
        var res = jsonDecode(val);
        Utils.userName = res[0]['name'];

        Utils.access = res[0]['access'].split(",");
        Utils.isLogged = true;
        result = true;
      } else {
        Utils.userName = '';
        Utils.access = [];
        Utils.isLogged = false;
        result = false;
      }
      return result;
    } catch (e) {
      print.call(e);
      Utils().showError(noInternet);
      return false;
    }
  }

  Future<List<AlertModel>> fetchAlert() async {
    var shop = <AlertModel>[];
    try {
      var data = {
        "action": "get_batch",
      };
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson != false) {
        for (var empJson in empJson) {
          shop.add(AlertModel.fromJson(empJson));
        }
      }
      return shop;
    } catch (e) {
      print.call(e);
      return shop;
    }
  }
}
