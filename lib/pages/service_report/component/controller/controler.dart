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

class SRCon extends GetxController {
  final formKey = GlobalKey<FormState>();
  List<SRModel> ss = <SRModel>[];
  List<SRModel> ssList = <SRModel>[];
  final name = TextEditingController();
  final branchID = TextEditingController();

  dynamic total = 0.0;
  String selectedDate = "";
  dynamic discountAmount = 0.0;
  dynamic payable = 0.0;
  dynamic salesAmount = 0.0;
  dynamic payment = 0.0;
  dynamic balance = 0.0;
  String pdate = '';
  String rep = '';
  String customer = '';
  String invoiceID = '';
  String branch = '';
  List<SDModel> sd = <SDModel>[];
  List<String> st = ['All', 'Direct sales', 'Proforma'];
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
    // getData();
    getBranch();
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

  getSalesDetails(String id, BuildContext context) {
    isPrint.value = true;
    fetchSalesDetail(id).then((value) {
      sd = [];
      sd.addAll(value);
      isPrint.value = false;
      printDialog(context);
    });
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
              height: myHeight(context, 2),
              child: PdfPreview(
                canDebug: false,
                padding: const EdgeInsets.all(2.0),
                build: (format) => SalesReceipt(
                        sd: sd,
                        invoiceID: invoiceID,
                        context: context,
                        branch: branch,
                        customer: customer,
                        rep: rep,
                        booking: pdate,
                        total: Utils().formatPrice(total),
                        discount: Utils().formatPrice(discountAmount),
                        payable: Utils().formatPrice(payable),
                        payment: Utils().formatPrice(payment),
                        balance: Utils().formatPrice(balance))
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
        "action": "view_sales",
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
        "action": "search_sales",
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
