import 'dart:convert';

import '../../../../services/widgets/dropdown.dart';
import '../model.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/utils/query.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../branches/component/controller/controller.dart';
import '../../../income/entry/component/model.dart';

final b = Get.find<BranchesCon>();

class CashFlowCon extends GetxController {
  List<MonthCashModel> income = <MonthCashModel>[];
  List<MonthCashModel> expenses = <MonthCashModel>[];
  List<SubCashModel> totalIncome = <SubCashModel>[];
  List<SubCashModel> totalIncomeCash = <SubCashModel>[];
  List<SubCashModel> totalExpenses = <SubCashModel>[];
  List<SubCashModel> netCash = <SubCashModel>[];
  List<SubCashModel> cashBalance = <SubCashModel>[];
  List<SubCashModel> endCash = <SubCashModel>[];
  List<CloseSales> closeSales = <CloseSales>[];
  List<String> closeList = [];
  List<DropDownModel> bList = [];
  DropDownModel? selBList;
  var isCS = false.obs;
  final branch = TextEditingController();
  final branchID = TextEditingController();
  final sdate = TextEditingController();
  final edate = TextEditingController();
  String selectedDate = "";
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  var setDate = false.obs;
  List<String> monthList = [];
  final selectedMonth = TextEditingController();
  final yearText = TextEditingController();
  int month = 0;
  var ism = false.obs;
  var isMonthPrint = false.obs;
  List<String> mLt = [];
  List<String> yLt = [];

  List<String> mLt2 = [];
  List<String> yLt2 = [];

  List<String> cl = [];
  List<String> subList = [];

  List<String> rType = [];
  List<String> subCat = [];
  List<String> category = [];

  int currentYear = DateTime.now().year;
  var isB = false.obs;
  @override
  void onInit() async {
    Utils.checkAccess();
    reload();
    super.onInit();
  }

  void reload() {
    getMonthYear();
    getMonthYear2();
    getBranch();
    update();
  }

  getBranch() {
    isB.value = true;
    b.fetchServiceCategory().then((value) {
      b.cat = [];
      b.cat.addAll(value);
      bList = [];
      for (int i = 0; i < b.cat.length; i++) {
        bList.add(DropDownModel(id: b.cat[i].id, name: b.cat[i].name));
      }
      isB.value = false;
    });
  }

  void getMonthYear2() {
    ism.value = true;
    yLt2.clear();
    yLt2.add("ALL");
    for (int i = 2021; i <= currentYear; i++) {
      yLt2.add(i.toString());
    }

    mLt2.clear();
    mLt2.add("ALL");
    for (int i = 1; i < 13; i++) {
      mLt2.add(Utils.myMonth(i));
    }
    ism.value = false;
  }

  void getMonthYear() {
    ism.value = true;
    yLt.clear();
    for (int i = 2021; i <= currentYear; i++) {
      yLt.add(i.toString());
    }
    mLt.clear();
    for (int i = 1; i < 13; i++) {
      mLt.add(Utils.myMonth(i));
    }
    ism.value = false;
  }

  monthlyCashflow(String date) {
    isMonthPrint.value = true;
    getCashBalance(date).then((value) {
      cashBalance = [];
      cashBalance.addAll(value);
      incomeFetch(date).then((value) {
        getTotalIncome(date).then((value) {
          totalIncome = [];
          totalIncome.addAll(value);
          getTotalIncomeCash(date).then((value) {
            totalIncomeCash = [];
            totalIncomeCash.addAll(value);
            expensesFetch(date).then((value) {
              getTotalExpenses(date).then((value) {
                totalExpenses = [];
                totalExpenses.addAll(value);
                getNetCash(date).then((value) {
                  netCash = [];
                  netCash.addAll(value);
                  getEndCash(date).then((value) {
                    endCash = [];
                    endCash.addAll(value);
                    isMonthPrint.value = false;
                    pp.value = false;
                    printPreviewY.value = false;
                    printPreviewM.value = true;
                    pp.value = true;
                    Get.back();
                    // Get.to(
                    //   CashflowPrint(
                    //     title: "Cashflow report on ${selectedMonth.text}",
                    //     income: income,
                    //     expenses: expenses,
                    //     cashBal: cashBalance,
                    //     totalCashInflow: totalIncome,
                    //     totalCashOutflow: totalExpenses,
                    //     endCash: endCash,
                    //     incomecashBalance: totalIncomeCash,
                    //     netCash: netCash,
                    //   ),
                    // );
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  getCloseSales(String branch) {
    isCS.value = true;
    fetchClosedSales(branch).then((value) {
      closeSales = [];
      closeList = [];
      closeSales.addAll(value);
      for (int i = 0; i < closeSales.length; i++) {
        closeList.add(
            "${Utils.myMonth(int.parse(closeSales[i].month))} ${closeSales[i].year}");
      }
      isCS.value = false;
    });
  }

  Future incomeFetch(String date) async {
    List<MonthCashModel> inc = <MonthCashModel>[];
    var subList = <SubMonthCashModel>[];
    var subTotal = <SubCashModel>[];
    try {
      var query = {"action": "view_income_category"};
      var val = await Query.queryData(query);
      if (jsonDecode(val) != 'false') {
        var lists = jsonDecode(val);
        for (int i = 0; i < lists.length; i++) {
          var data = {
            "action": "view_income_entry",
            "category": lists[i]['name'].toString(),
            "date": date,
            "branch": branch.text
          };
          var res = await Query.queryData(data);

          if (jsonDecode(res) != 'false') {
            var productsJson = jsonDecode(res);
            subList = [];
            for (var productJson in productsJson) {
              subList.add(SubMonthCashModel.fromJson(productJson));
            }
          }
          var data2 = {
            "action": "view_income_entry_total",
            "category": lists[i]['name'].toString(),
            "date": date,
            "branch": branch.text
          };
          var res2 = await Query.queryData(data2);
          if (jsonDecode(res2) != 'false') {
            var productsJson = jsonDecode(res2);
            subTotal = [];
            for (var productJson in productsJson) {
              subTotal.add(SubCashModel.fromJson(productJson));
            }
          }
          inc.add(MonthCashModel(
              id: lists[i]['id'],
              subList: subList,
              name: lists[i]['name'],
              subTotal: subTotal));
        }
        income = [];
        income = inc;
      }
    } catch (e) {
      print(e);
    }
  }

  Future expensesFetch(String date) async {
    List<MonthCashModel> inc = <MonthCashModel>[];
    var subList = <SubMonthCashModel>[];
    var subTotal = <SubCashModel>[];
    try {
      var query = {"action": "view_expenses_category"};
      var val = await Query.queryData(query);
      if (jsonDecode(val) != 'false') {
        var lists = jsonDecode(val);
        for (int i = 0; i < lists.length; i++) {
          var data = {
            "action": "view_expenses_entry",
            "category": lists[i]['name'].toString(),
            "date": date,
            "branch": branch.text
          };
          var res = await Query.queryData(data);
          if (jsonDecode(res) != 'false') {
            var productsJson = jsonDecode(res);
            subList = [];
            for (var productJson in productsJson) {
              subList.add(SubMonthCashModel.fromJson(productJson));
            }
          }
          var data2 = {
            "action": "view_expenses_entry_total",
            "category": lists[i]['name'].toString(),
            "branch": branch.text,
            "date": date,
          };
          var res2 = await Query.queryData(data2);
          if (jsonDecode(res2) != 'false') {
            var productsJson = jsonDecode(res2);
            subTotal = [];
            for (var productJson in productsJson) {
              subTotal.add(SubCashModel.fromJson(productJson));
            }
          }
          inc.add(MonthCashModel(
              id: lists[i]['id'],
              subList: subList,
              name: lists[i]['name'],
              subTotal: subTotal));
        }
        expenses = [];
        expenses = inc;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<SubCashModel>> getTotalIncome(String date) async {
    var products = <SubCashModel>[];
    try {
      var data = {
        "action": "income_total",
        "date": date,
        "branch": branch.text
      };
      var res = await Query.queryData(data);

      if (jsonDecode(res) != 'false') {
        var productsJson = jsonDecode(res);
        for (var productJson in productsJson) {
          products.add(SubCashModel.fromJson(productJson));
        }
      }
      return products;
    } catch (e) {
      print.call(e);
      return products;
    }
  }

  Future<List<SubCashModel>> getTotalIncomeCash(String date) async {
    var products = <SubCashModel>[];
    try {
      var spliter = [];
      spliter = selectedMonth.text.split(" ");
      String year = spliter[1].toString().trim();
      String month = Utils.myMonthNumber(spliter[0]).toString().trim();
      var data = {
        "action": "income_cash_total",
        "date": date,
        "year": year,
        "month": month,
        "branch": branch.text
      };
      var res = await Query.queryData(data);
      if (jsonDecode(res) != 'false') {
        var productsJson = jsonDecode(res);
        for (var productJson in productsJson) {
          products.add(SubCashModel.fromJson(productJson));
        }
      }
      return products;
    } catch (e) {
      print.call(e);
      return products;
    }
  }

  Future<List<SubCashModel>> getTotalExpenses(String date) async {
    var products = <SubCashModel>[];
    try {
      var data = {
        "action": "expenses_total",
        "date": date,
        "branch": branch.text
      };
      var res = await Query.queryData(data);
      if (jsonDecode(res) != 'false') {
        var productsJson = jsonDecode(res);
        for (var productJson in productsJson) {
          products.add(SubCashModel.fromJson(productJson));
        }
      }
      return products;
    } catch (e) {
      print.call(e);
      return products;
    }
  }

  Future<List<SubCashModel>> getNetCash(String date) async {
    var products = <SubCashModel>[];
    try {
      var spliter = [];
      spliter = selectedMonth.text.split(" ");
      String year = spliter[1].toString().trim();
      String month = Utils.myMonthNumber(spliter[0]).toString().trim();
      var data = {
        "action": "net_cash",
        "date": date,
        "year": year,
        "month": month,
        "branch": branch.text
      };
      var res = await Query.queryData(data);
      if (jsonDecode(res) != 'false') {
        var productsJson = jsonDecode(res);
        for (var productJson in productsJson) {
          products.add(SubCashModel.fromJson(productJson));
        }
      }
      return products;
    } catch (e) {
      print.call(e);
      return products;
    }
  }

  Future<List<SubCashModel>> getEndCash(String date) async {
    var products = <SubCashModel>[];
    try {
      var spliter = [];
      spliter = selectedMonth.text.split(" ");
      String year = spliter[1].toString().trim();
      String month = Utils.myMonthNumber(spliter[0]).toString().trim();
      var data = {
        "action": "end_cash",
        "date": date,
        "year": year,
        "month": month,
        "branch": branch.text
      };
      var res = await Query.queryData(data);
      if (jsonDecode(res) != 'false') {
        var productsJson = jsonDecode(res);
        for (var productJson in productsJson) {
          products.add(SubCashModel.fromJson(productJson));
        }
      }
      return products;
    } catch (e) {
      print.call(e);
      return products;
    }
  }

  Future<List<SubCashModel>> getCashBalance(String date) async {
    var products = <SubCashModel>[];
    try {
      var spliter = [];
      spliter = selectedMonth.text.split(" ");
      String year = spliter[1].toString().trim();
      String month = Utils.myMonthNumber(spliter[0]).toString().trim();
      var data = {
        "action": "cash_balance",
        "year": year,
        "month": month,
        "branch": branch.text
      };
      var res = await Query.queryData(data);
      if (jsonDecode(res) != 'false') {
        var productsJson = jsonDecode(res);
        for (var productJson in productsJson) {
          products.add(SubCashModel.fromJson(productJson));
        }
      }
      return products;
    } catch (e) {
      print.call(e);
      return products;
    }
  }

  Future<List<CloseSales>> fetchClosedSales(String branch) async {
    var products = <CloseSales>[];
    try {
      var data = {"action": "view_closed_sales", "branch": branch};
      var res = await Query.queryData(data);
      if (jsonDecode(res) != 'false') {
        var productsJson = jsonDecode(res);
        for (var productJson in productsJson) {
          products.add(CloseSales.fromJson(productJson));
        }
      }
      return products;
    } catch (e) {
      print.call(e);
      return products;
    }
  }

  /// -------------------------------for the year  calculation-----------------------------------------------------------------

  List<YearCashModel> yIncome = <YearCashModel>[];
  List<YearCashModel> yExpenses = <YearCashModel>[];
  List<SubCashYearModel> yTotalIncome = <SubCashYearModel>[];
  List<SubCashYearModel> yTotalIncomeCash = <SubCashYearModel>[];
  List<SubCashYearModel> yTotalExpenses = <SubCashYearModel>[];
  List<SubCashYearModel> yNetCash = <SubCashYearModel>[];
  List<SubCashYearModel> yCashBalance = <SubCashYearModel>[];
  List<SubCashYearModel> yEndCash = <SubCashYearModel>[];
  List<String> yearList = [];
  var isYear = false.obs;
  var isYearPrint = false.obs;
  var pp = false.obs;
  var printPreviewM = false.obs;
  var printPreviewY = false.obs;
  final selectedYear = TextEditingController();

  yearlyCashflow(String year) {
    isYearPrint.value = true;
    getYearCashBalance(year).then((value) {
      yCashBalance = [];
      yCashBalance.addAll(value);
      yIncomeFetch(year).then((value) {
        getYearTotalIncome(year).then((value) {
          yTotalIncome = [];
          yTotalIncome.addAll(value);
          getYearTotalIncomeCash(year).then((value) {
            yTotalIncomeCash = [];
            yTotalIncomeCash.addAll(value);
            yExpensesFetch(year).then((value) {
              getYearTotalExpenses(year).then((value) {
                yTotalExpenses = [];
                yTotalExpenses.addAll(value);
                getYearNetCash(year).then((value) {
                  yNetCash = [];
                  yNetCash.addAll(value);
                  getYearEndCash(year).then((value) {
                    yEndCash = [];
                    yEndCash.addAll(value);
                    isYearPrint.value = false;
                    pp.value = false;
                    printPreviewY.value = true;
                    printPreviewM.value = false;
                    pp.value = true;
                    Get.back();
                    // Get.to(
                    //   YearCashflowPrint(
                    //     title: "Cashflow report on ${yearText.text}",
                    //     income: yIncome,
                    //     expenses: yExpenses,
                    //     cashBal: yCashBalance,
                    //     totalCashInflow: yTotalIncome,
                    //     totalCashOutflow: yTotalExpenses,
                    //     endCash: yEndCash,
                    //     incomecashBalance: yTotalIncomeCash,
                    //     netCash: yNetCash,
                    //   ),
                    // );
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  getYear(String branch) {
    isYear.value = true;
    fetchClosedSales(branch).then((value) {
      closeSales = [];
      yearList = [];
      closeSales.addAll(value);
      for (int i = 0; i < closeSales.length; i++) {
        yearList.add(closeSales[i].year.toString());
      }
      isYear.value = false;
    });
  }

  Future yIncomeFetch(String year) async {
    List<YearCashModel> inc = <YearCashModel>[];
    var subList = <SubYearCashModel>[];
    var subTotal = <SubCashYearModel>[];
    try {
      var query = {"action": "view_year_income_category"};
      var val = await Query.queryData(query);

      if (jsonDecode(val) != 'false') {
        var lists = jsonDecode(val);
        for (int i = 0; i < lists.length; i++) {
          var data = {
            "action": "view_year_income_entry",
            "category": lists[i]['name'].toString(),
            "year": year,
            "branch": branch.text
          };
          var res = await Query.queryData(data);

          if (jsonDecode(res) != 'false') {
            var productsJson = jsonDecode(res);
            subList = [];
            for (var productJson in productsJson) {
              subList.add(SubYearCashModel.fromJson(productJson));
            }
          }
          var data2 = {
            "action": "view_year_income_entry_total",
            "category": lists[i]['name'].toString(),
            "year": year,
            "branch": branch.text
          };

          var res2 = await Query.queryData(data2);

          if (jsonDecode(res2) != 'false') {
            var productsJson = jsonDecode(res2);
            subTotal = [];
            for (var productJson in productsJson) {
              subTotal.add(SubCashYearModel.fromJson(productJson));
            }
          }
          inc.add(YearCashModel(
              id: lists[i]['id'],
              subList: subList,
              name: lists[i]['name'],
              subTotal: subTotal));
        }
        yIncome = [];
        yIncome = inc;
      }
    } catch (e) {
      print(e);
    }
  }

  Future yExpensesFetch(String year) async {
    List<YearCashModel> inc = <YearCashModel>[];
    var subList = <SubYearCashModel>[];
    var subTotal = <SubCashYearModel>[];
    try {
      var query = {"action": "view_year_expenses_category"};
      var val = await Query.queryData(query);
      if (jsonDecode(val) != 'false') {
        var lists = jsonDecode(val);
        for (int i = 0; i < lists.length; i++) {
          var data = {
            "action": "view_year_expenses_entry",
            "category": lists[i]['name'].toString(),
            "year": year,
            "branch": branch.text
          };

          var res = await Query.queryData(data);

          if (jsonDecode(res) != 'false') {
            var productsJson = jsonDecode(res);
            subList = [];
            for (var productJson in productsJson) {
              subList.add(SubYearCashModel.fromJson(productJson));
            }
          }
          var data2 = {
            "action": "view_year_expenses_entry_total",
            "category": lists[i]['name'].toString(),
            "year": year,
            "branch": branch.text
          };
          var res2 = await Query.queryData(data2);

          if (jsonDecode(res2) != 'false') {
            var productsJson = jsonDecode(res2);
            subTotal = [];
            for (var productJson in productsJson) {
              subTotal.add(SubCashYearModel.fromJson(productJson));
            }
          }
          inc.add(YearCashModel(
              id: lists[i]['id'],
              subList: subList,
              name: lists[i]['name'],
              subTotal: subTotal));
        }
        yExpenses = [];
        yExpenses = inc;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<SubCashYearModel>> getYearTotalIncome(String year) async {
    var products = <SubCashYearModel>[];
    try {
      var data = {
        "action": "year_income_total",
        "year": year,
        "branch": branch.text
      };
      var res = await Query.queryData(data);
      if (jsonDecode(res) != 'false') {
        var productsJson = jsonDecode(res);
        for (var productJson in productsJson) {
          products.add(SubCashYearModel.fromJson(productJson));
        }
      }
      return products;
    } catch (e) {
      print.call(e);
      return products;
    }
  }

  Future<List<SubCashYearModel>> getYearTotalIncomeCash(String year) async {
    var products = <SubCashYearModel>[];
    try {
      var data = {
        "action": "year_income_cash_total",
        "year": year,
        "branch": branch.text
      };
      var res = await Query.queryData(data);
      if (jsonDecode(res) != 'false') {
        var productsJson = jsonDecode(res);
        for (var productJson in productsJson) {
          products.add(SubCashYearModel.fromJson(productJson));
        }
      }
      return products;
    } catch (e) {
      print.call(e);
      return products;
    }
  }

  Future<List<SubCashYearModel>> getYearTotalExpenses(String year) async {
    var products = <SubCashYearModel>[];
    try {
      var data = {
        "action": "year_expenses_total",
        "year": year,
        "branch": branch.text
      };
      var res = await Query.queryData(data);

      if (jsonDecode(res) != 'false') {
        var productsJson = jsonDecode(res);
        for (var productJson in productsJson) {
          products.add(SubCashYearModel.fromJson(productJson));
        }
      }
      return products;
    } catch (e) {
      print.call(e);
      return products;
    }
  }

  Future<List<SubCashYearModel>> getYearNetCash(String year) async {
    var products = <SubCashYearModel>[];
    try {
      var data = {
        "action": "year_net_cash",
        "year": year,
        "branch": branch.text
      };
      var res = await Query.queryData(data);
      if (jsonDecode(res) != 'false') {
        var productsJson = jsonDecode(res);
        for (var productJson in productsJson) {
          products.add(SubCashYearModel.fromJson(productJson));
        }
      }
      return products;
    } catch (e) {
      print.call(e);
      return products;
    }
  }

  Future<List<SubCashYearModel>> getYearEndCash(String year) async {
    var products = <SubCashYearModel>[];
    try {
      var data = {
        "action": "year_end_cash",
        "year": year,
        "branch": branch.text
      };
      var res = await Query.queryData(data);
      if (jsonDecode(res) != 'false') {
        var productsJson = jsonDecode(res);
        for (var productJson in productsJson) {
          products.add(SubCashYearModel.fromJson(productJson));
        }
      }
      return products;
    } catch (e) {
      print.call(e);
      return products;
    }
  }

  Future<List<SubCashYearModel>> getYearCashBalance(String year) async {
    var products = <SubCashYearModel>[];
    try {
      var data = {
        "action": "year_cash_balance",
        "year": year,
        "branch": branch.text
      };
      var res = await Query.queryData(data);
      if (jsonDecode(res) != 'false') {
        var productsJson = jsonDecode(res);
        for (var productJson in productsJson) {
          products.add(SubCashYearModel.fromJson(productJson));
        }
      }
      return products;
    } catch (e) {
      isYearPrint.value = false;
      print.call(e);
      return products;
    }
  }

  Future<List<CloseSales>> fetchYear(String branch) async {
    var products = <CloseSales>[];
    try {
      var data = {"action": "view_year_list", "branch": branch};
      var res = await Query.queryData(data);
      if (jsonDecode(res) != 'false') {
        var productsJson = jsonDecode(res);
        for (var productJson in productsJson) {
          products.add(CloseSales.fromJson(productJson));
        }
      }
      return products;
    } catch (e) {
      print.call(e);
      return products;
    }
  }
}
