import 'dart:math';

import 'package:currency_formatter/currency_formatter.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../constants/color.dart';
import '../constants/constant.dart';

class Utils {
  static bool isLogged = false;
  static String userName = '';
  static var uid = ''.obs;
  String uidd = '';
  static String userRole = '';
  static String userEmail = '';
  static String branchID = '';
  static List<String> access = [];

  static var iv = enc.IV.fromLength(16);
  static var key = enc.Key.fromLength(32);
  static final isLightTheme = false.obs;

  static int daysDifference(DateTime from, DateTime to) {
    int days = to.difference(from.subtract(const Duration(days: 1))).inDays;
    int sunday = getSundays(from, to);
    days = days - sunday;
    return days;
  }

  static checkAccess() {
    if (uid.value.isEmpty) {
      Get.toNamed('/auth');
    }
  }

  static logOut() {
    uid.value = '';
    Get.toNamed('/auth');
  }

  static int hoursDifference(
      DateTime from, DateTime to, int weekH, int weekendH) {
    int sunday = getSundays(from, to);
    int saturday = getSaturday(from, to);
    int d = 0;
    to = to.subtract(Duration(days: sunday));
    to = to.subtract(Duration(days: saturday));
    d = to.difference(from.subtract(const Duration(days: 1))).inDays;
    int weekhour = d * weekH;
    int wknHours = saturday * weekendH;
    int hours = weekhour + wknHours;
    return hours;
  }

  static timeDifference(var starTime, var endTime) {
    var format = DateFormat("HH:mm");
    var one = format.parse(starTime);
    var two = format.parse(endTime);
    return two.difference(one); // prints 7:40
  }

  static stringToList(String value) {
    final regExp = RegExp(r'(?:\[)?(\[[^\]]*?\](?:,?))(?:\])?');
    final input = value;
    final result = regExp
        .allMatches(input)
        .map((m) => m.group(1))
        .map((String? item) => item!.replaceAll(RegExp(r'[\[\],]'), ''))
        .map((m) => [m])
        .toList();
    return result;
  }

  static dateFormat(dynamic date) {
    var format = DateFormat("'yyyy-MM-dd HH:mm");
    var newDate = format.parse(date);

    return newDate;
  }

  static dateOnly(dynamic date) {
    // var format = DateFormat("'yyyy-MM-dd");
    // DateTime newDate = format.parse(date);
    // return newDate;
    DateTime dateToday = date;
    String newdate = dateToday.toString().substring(0, 10);
    return newdate;
  }

  static String formatNumber(var number) {
    var formatter = NumberFormat('#,##,000');
    return formatter.format(number);
  }

  static int getSundays(DateTime from, DateTime to) {
    int days = to.difference(from.subtract(const Duration(days: 1))).inDays;
    from = from.subtract(const Duration(days: 1));
    int sunday = 0;
    for (int i = 0; i <= days; i++) {
      if (from.add(Duration(days: i)).weekday == DateTime.sunday) {
        sunday += 1;
      }
    }
    return sunday;
  }

  static convertTime(int seconds) {
    format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
    return format(Duration(seconds: seconds));
  }

  static int getSaturday(DateTime from, DateTime to) {
    int days = to.difference(from.subtract(const Duration(days: 1))).inDays;
    from = from.subtract(const Duration(days: 1));
    int saturday = 0;
    for (int i = 0; i <= days; i++) {
      if (from.add(Duration(days: i)).weekday == DateTime.saturday) {
        saturday += 1;
      }
    }
    return saturday;
  }

  static String myMonth(int value) {
    String m = '';
    if (value == 1) {
      m = 'January';
    } else if (value == 2) {
      m = 'February';
    } else if (value == 3) {
      m = 'March';
    } else if (value == 4) {
      m = 'April';
    } else if (value == 5) {
      m = 'May';
    } else if (value == 6) {
      m = 'June';
    } else if (value == 7) {
      m = 'July';
    } else if (value == 8) {
      m = 'August';
    } else if (value == 9) {
      m = 'September';
    } else if (value == 10) {
      m = 'October';
    } else if (value == 11) {
      m = 'November';
    } else {
      m = 'December';
    }
    return m;
  }

  static int myMonthNumber(String value) {
    int m = 0;
    if (value == 'January') {
      m = 1;
    } else if (value == 'February') {
      m = 2;
    } else if (value == 'March') {
      m = 3;
    } else if (value == 'April') {
      m = 4;
    } else if (value == 'May') {
      m = 5;
    } else if (value == 'June') {
      m = 6;
    } else if (value == 'July') {
      m = 7;
    } else if (value == 'August') {
      m = 8;
    } else if (value == 'September') {
      m = 9;
    } else if (value == 'October') {
      m = 10;
    } else if (value == 'November') {
      m = 11;
    } else {
      m = 12;
    }
    return m;
  }

//encrypt
  static String encryptMyData(String text) {
    try {
      if (text.isNotEmpty) {
        final e = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
        final encryptedData = e.encrypt(text, iv: iv);
        return encryptedData.base64;
      } else {
        return text;
      }
    } catch (e) {
      print.call(e);
      return text;
    }
  }

  static userNameinitials(String val) {
    List<String> spliter = val.trim().split(" ");
    // String label = '';
    // for (int i = 0; i < spliter.length; i++) {
    //   label = label + spliter[i].trim()[0].toUpperCase();
    // }
    return spliter[0].trim();
  }

  static spaceLink(String val, int num) {
    // List<String> spliterSlash = val.trim().split("/");
    List<String> spliter = val.trimLeft().split("_");
    String label = '';
    for (int i = 0; i < spliter.length; i++) {
      label = label + spliter[i].trim()[0].toUpperCase();
    }
    label = label + num.toString();
    return label;
  }

  static initials(String val, int num) {
    List<String> spliter = val.trim().split(" ");
    String label = '';
    for (int i = 0; i < spliter.length; i++) {
      label = label + spliter[i].trim()[0].toUpperCase();
    }
    label = label + num.toString();
    return label;
  }

  static bool isNumeric(String s) {
    if (s.isEmpty) {
      return false;
    }
    return double.tryParse(s) != null;
  }

//dycrypt
  static String decryptMyData(String text) {
    try {
      if (text.isNotEmpty) {
        final e = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
        final decryptedData = e.decrypt(enc.Encrypted.fromBase64(text), iv: iv);
        return decryptedData;
      } else {
        return text;
      }
    } catch (e) {
      print.call(e);
      return text;
    }
  }

  static String decryptList(String text) {
    String decryptedData = '';
    try {
      if (text.isNotEmpty) {
        List list = text.split(",");
        var value = '';
        for (int i = 0; i < list.length; i++) {
          value = '';
          final e = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
          value = e.decrypt(enc.Encrypted.fromBase64(list[i]), iv: iv);
          decryptedData = "$decryptedData,$value";
        }
        decryptedData = decryptedData.substring(1);
        return decryptedData;
      } else {
        return decryptedData;
      }
    } catch (e) {
      print.call(e);
      return decryptedData;
    }
  }

  static String encryptList(String text) {
    String encryptedData = '';
    try {
      if (text.isNotEmpty) {
        List list = text.split(",");
        for (int i = 0; i < list.length; i++) {
          final e = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
          final value = e.encrypt(list[i], iv: iv);
          encryptedData = "$encryptedData,${value.base64}";
        }
        encryptedData = encryptedData.substring(1);
        return encryptedData;
      } else {
        return encryptedData;
      }
    } catch (e) {
      print.call(e);
      return encryptedData;
    }
  }

  static getRandomNumbers() {
    var rng = Random();
    var code = rng.nextInt(900000) + 100000;
    return code.toString();
  }

  static getTodaysDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    return formatted;
  }

  showError(String error) {
    Get.snackbar(
      appName,
      error,
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
      icon: Icon(Icons.error, color: errorColor),
      duration: const Duration(seconds: 5),
    );
  }

  static printInfo(var data) {
    print.call(data);
  }

  showInfo(String info) {
    Get.snackbar(
      appName, info,
      snackPosition: SnackPosition.BOTTOM,
      icon: Icon(Icons.info, color: greenfade),
      duration: const Duration(seconds: 3),
      forwardAnimationCurve: Curves.easeInOut,
      isDismissible: true,
      // boxShadows: [
      //   const BoxShadow(
      //       color: Colors.grey,
      //       offset: Offset(30, 50),
      //       spreadRadius: 20,
      //       blurRadius: 5)
      // ]
    );
  }

  static String? validator(String? value) {
    if (value!.isEmpty) {
      return 'Please this field is required';
    }
    return null;
  }

//set sunday value to 0
  static int getAdjustedWeekday(DateTime dateTime) => dateTime.weekday % 7;

  // static formatPrice(dynamic price) => '¢ ${price.toStringAsFixed(2)}';

  String formatPrice(dynamic price) =>
      CurrencyFormatter.format(price, cedisettings);

  CurrencyFormatterSettings cedisettings = CurrencyFormatterSettings(
    symbol: '¢',
    symbolSide: SymbolSide.left,
    thousandSeparator: ',',
    decimalSeparator: '.',
    symbolSeparator: ' ',
  );
  static formatDate(DateTime date) => DateFormat.yMd().format(date);

  static mergeName(String surname, String firstname, String? middlename) {
    return "${surname.trim().toUpperCase()}, ${middlename!.trim().capitalize} ${firstname.trim().capitalize}";
  }
}

extension Capitalized on String {
  String capitalized() =>
      substring(0, 1).toUpperCase() + substring(1).toLowerCase();
}

extension DateTimeX on DateTime {
  DateTime get currentDateOnly => DateTime(year, month, day);
  String dateFormatString() => DateFormat('EEE, dd-MMM-yy').format(this);

  //format 29-sep-2022 - 3:31 PM
  String dateTimeFormatString() =>
      DateFormat('dd-MMM-yyyy - hh:mm aaa').format(this);

  //format 29-sep-22 - 3:31 PM
  String dateTimeFormatShortString() =>
      DateFormat('dd-MMM-yy - hh:mm aaa').format(this);

  String dateOnlyFormatShortString() => DateFormat('dd-MMM-yyyy').format(this);
}
