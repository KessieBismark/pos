import 'dart:convert';

import 'package:get/get.dart';

import '../../../../services/utils/helpers.dart';
import '../../../../services/utils/query.dart';
import '../models/model.dart';

class DashCon extends GetxController {
  List<FastSMondel> fastseling = <FastSMondel>[];
  List<NetProfitModel> netProfit = <NetProfitModel>[];
  List<ActModel> cashflow = <ActModel>[];
  List<ActModelT> cashtype = <ActModelT>[];
  var totalSales = 0.0.obs;
  var instant = '0'.obs;
  var booking = '0'.obs;
  var isFastLoad = false.obs;
  var loadcf = false.obs;
  var loadtcf = false.obs;
  var isNetLoad = false.obs;

  var isDay = true.obs;
  var isMonth = false.obs;
  var isYear = false.obs;
  var isWeek = false.obs;
  @override
  void onInit() {
    super.onInit();
    Utils.checkAccess();
    reload();
  }

  reload() {
    getFastSelling();
    sales();
    getNetProfit("day");
    getCashflow();
  }

  void getCashflow() {
    loadcf.value = true;

    fetchCashflow().then((value) {
      cashflow = [];
      cashflow.addAll(value);
      loadcf.value = false;
    });
  }

  getFastSelling() {
    isFastLoad.value = true;
    fetchFastSelling().then((value) {
      fastseling = [];
      fastseling.addAll(value);
      isFastLoad.value = false;
    });
  }

  getNetProfit(String period) {
    isNetLoad.value = true;
    fetchNetProfit(period).then((value) {
      netProfit = [];
      netProfit.addAll(value);
      isNetLoad.value = false;
    });
  }

  sales() async {
    try {
      var query = {
        "action": "dash_sales",
      };
      var val = await Query.queryData(query);
      if (jsonDecode(val) != 'false') {
        var res = jsonDecode(val);
        totalSales.value =double.parse( res[0]['sales']);
        instant.value =res[0]['instant'];
        booking.value = res[0]['booking'];
      }
    } catch (e) {
      print.call(e);
    }
  }

  Future<List<FastSMondel>> fetchFastSelling() async {
    var record = <FastSMondel>[];
    try {
      var data = {
        "action": "view_fast_selling",
      };
      var result = await Query.queryData(data);
      var res = json.decode(result);
      for (var res in res) {
        record.add(FastSMondel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }

  Future<List<ActModel>> fetchCashflow() async {
    var shop = <ActModel>[];
    try {
      var data = {"action": "casflow_main"};
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      for (var empJson in empJson) {
        shop.add(ActModel.fromJson(empJson));
      }

      return shop;
    } catch (e) {
      print.call(e);
      return shop;
    }
  }

  Future<List<NetProfitModel>> fetchNetProfit(String period) async {
    var record = <NetProfitModel>[];
    try {
      var data = {"action": "view_net_profit", "period": period};
      var result = await Query.queryData(data);
      var res = json.decode(result);
      for (var res in res) {
        record.add(NetProfitModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }
}
