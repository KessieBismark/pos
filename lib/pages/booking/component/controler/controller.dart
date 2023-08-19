import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/helpers.dart';
import '../../../../services/utils/query.dart';
import '../../../../services/widgets/button.dart';
import '../../../../services/widgets/dropdown.dart';
import '../../../branches/component/controller/controller.dart';
import '../model.dart';
import '../print/print_class.dart';

final b = Get.find<BranchesCon>();

class BookingCon extends GetxController {
  final formKey = GlobalKey<FormState>();
  List<SRModel> ss = <SRModel>[];
  List<SRModel> ssList = <SRModel>[];
  dynamic total = 0.0;
  dynamic discountAmount = 0.0;
  dynamic payable = 0.0;
  dynamic salesAmount = 0.0;
  final payment = TextEditingController();
  final branchID = TextEditingController();
  var balance = 0.0.obs;
  String pdate = '';
  String selectedDate = "";
  String rep = '';
  String customer = '';
  String invoiceID = '';
  String branch = '';
  List<SDModel> sd = <SDModel>[];
  List<String> st = ['All', 'Paid', 'Unpaid'];
  final selST = TextEditingController().obs;
  List<DropDownModel> bList = [];
  DropDownModel? selBList;
  var isB = false.obs;
  var loading = false.obs;
  var isSave = false.obs;
  var setDate = false.obs;
  var isPrint = false.obs;
  final sdate = TextEditingController();
  final edate = TextEditingController();
  var sortNameAscending = false.obs;
  var sortNameIndex = 1.obs;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    Utils.checkAccess();
    reload();
  }

  reload() {
    getBranch();
  }

  searchData() {
    loading.value = true;
    fetchSalesSearch().then((value) {
      ss = [];
      ssList = [];
      ss.addAll(value);
      ssList = ss;
      loading.value = false;
    });
  }

  getBranch() {
    isB.value = true;
    b.fetchServiceCategory().then((value) {
      b.cat = [];
      b.cat.addAll(value);
      bList = [];
      bList.add(DropDownModel(id: '0', name: "All"));
      for (int i = 0; i < b.cat.length; i++) {
        bList.add(DropDownModel(id: b.cat[i].id, name: b.cat[i].name));
      }
      isB.value = false;
    });
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

  getSalesDetails(String id, BuildContext context) {
    isPrint.value = true;
    fetchSalesDetail(id).then((value) {
      sd = [];
      sd.addAll(value);
      isPrint.value = false;
      printDialog(context);
    });
  }

  payBooking({required String id}) async {
    if (payment.text.isNotEmpty) {
      if (balance.value >= 0.0) {
        try {
          var query = {
            "action": "pay_booking",
            "id": id.toString(),
            "payment": payment.text.trim(),
            "balance": balance.value.toString()
          };
          var val = await Query.queryData(query);
          if (jsonDecode(val) == 'true') {
            searchData();
            Get.back();
            payment.clear();
            balance.value = 0.0;
          } else {
            Utils().showError(notSaved);
          }
        } catch (e) {
          print(e);
        }
      } else {
        Utils().showError("Amount payable is more than payment amount!");
      }
    } else {
      Utils().showError("Amount paid must be entered");
    }
  }

  printDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Print Preview",
      barrierDismissible: true,
      content: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 600,
              height: 500,
              child: PdfPreview(
                canDebug: false,
                padding: const EdgeInsets.all(0),
                build: (format) => SalesReceipt(
                        sd: sd,
                        invoiceID: invoiceID,
                        context: context,
                        branch: branch,
                        customer: customer,
                        rep: rep,
                        booking: pdate,
                        total: total,
                        discount: discountAmount,
                        payable: payable,
                        payment: double.parse(payment.text),
                        balance: balance.value)
                    .generatePdf(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MButton(
              onTap: () {
                Get.back();
              },
              type: ButtonType.cancel,
            )
          ],
        ),
      ),
    );
  }

  Future<List<SDModel>> fetchSalesDetail(String id) async {
    var record = <SDModel>[];
    try {
      var data = {"action": "view_sales_details", "id": id};
      var result = await Query.queryData(data);
      var res = json.decode(result);
      for (var res in res) {
        record.add(SDModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }

  Future<List<SRModel>> fetchServiceCategory() async {
    var record = <SRModel>[];
    try {
      var data = {
        "action": "view_booked_sales",
      };
      var result = await Query.queryData(data);
      var res = json.decode(result);
      for (var res in res) {
        record.add(SRModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }

  Future<List<SRModel>> fetchSalesSearch() async {
    var record = <SRModel>[];
    try {
      var data = {
        "action": "search_proforma_sales",
        "branch": branchID.text,
        "sdate": sdate.text,
        "edate": edate.text,
        'type': selST.value.text
      };
      var result = await Query.queryData(data);
      var res = json.decode(result);
      for (var res in res) {
        record.add(SRModel.fromJson(res));
      }
      return record;
    } catch (e) {
      print.call(e);
      return record;
    }
  }
}
