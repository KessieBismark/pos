import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/server.dart';

class Query {
  static Future queryData(var query) async {
    try {
      var res = await http.post(Uri.parse(Api.url), body: query);
      if (res.statusCode == 200) {
        return res.body;
      } else {
        print.call(res.body);
        return "false";
      }
    } catch (e) {
      print.call(e);
      return null;
    }
  }

  static Future login(var query) async {
    try {
      var res = await http.post(Uri.parse(Api.url), body: query);
      if (res.statusCode == 200 && jsonDecode(res.body) != 'false') {
        return res.body;
      } else {
        return jsonEncode('false');
      }
    } catch (e) {
      print.call(e);
      return null;
    }
  }

  static Future getValue(var query) async {
    try {
      var res = await http.post(Uri.parse(Api.url), body: query);
      if (res.statusCode == 200) {
        print.call(res.body);
        return res.body;
      } else {
        return "false";
      }
    } catch (e) {
      print.call(e);
      return null;
    }
  }

  // Future errorReport(String message) async {
  //   try {
  //     PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //     String appName = packageInfo.appName;
  //     //String? packageName = packageInfo.packageName;
  //     String version = packageInfo.version;
  //     // String? buildNumber = packageInfo.buildNumber;
  //     final res = await http.get(
  //         Uri.parse(
  //             "http://dashboard.eazismspro.com/sms/api?action=send-sms&api_key=OnNhbmtvZmExOQ==&to=0542089814&from=SenderID&sms= APP:$appName, VERSION:$version, COMPANY:$companyName, $message"),
  //         headers: {
  //           "Accept": "application/json",
  //           "Access-Control-Allow-Origin": "*"
  //         });

  //     return res.statusCode;
  //   } catch (e) {
  //     print.call(e);

  //     return null;
  //   }
  // }

  static Future recordCount(var query) async {
    try {
      var res = await http.post(Uri.parse(Api.url), body: query);
      if (res.statusCode == 200) {
        return res.body;
      } else {
        return "false";
      }
    } catch (e) {
      print.call(e);
      return null;
    }
  }

  static Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
