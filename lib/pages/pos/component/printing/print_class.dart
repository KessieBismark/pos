import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/company_details.dart';
import '../../../../services/utils/helpers.dart';
import '../controller/controller.dart';

class SalesReceipt {
  final BuildContext context;
  final POSCon controller;
  final List<dynamic> sd;
  final String invoiceID;
  final String customer;
  final String rep;
  final String? booking;
  final String branch;
  final String total;
  final String discount;
  final String payable;
  final String payment;
  final String balance;

  SalesReceipt(
      {required this.context,
      required this.sd,
      required this.branch,
      required this.controller,
      required this.invoiceID,
      required this.customer,
      required this.rep,
      required this.booking,
      required this.total,
      required this.discount,
      required this.payable,
      required this.payment,
      required this.balance});

  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    int number = 0;
    final image = await imageFromAssetBundle('assets/icons/logo.png');

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.symmetric(horizontal: 10),
        pageFormat: PdfPageFormat.a4.portrait,
        build: (context) => [
          pw.Column(
            children: [
              printHeader(image),
              pw.SizedBox(height: 20),
              invoiceLayer(),
              pw.SizedBox(
                height: 20,
              ),
              printTable(context, number),
              pw.SizedBox(
                height: 20,
              ),
              amountDetails(),
              pw.SizedBox(
                height: 50,
              ),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  "Thank you for doing business with us!",
                  //style: const pw.TextStyle(fontSize: 15)
                ),
              ),
              pw.SizedBox(
                height: 10,
              ),
              pw.Align(
                alignment: pw.Alignment.bottomLeft,
                child: pw.Text("Software by bistechgh.com"),
              )
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Column amountDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Align(
          alignment: pw.Alignment.bottomRight,
          child: pw.Text("Total: $total"),
        ),
        pw.Align(
          alignment: pw.Alignment.bottomRight,
          child: pw.Text("Dsicount: $discount"),
        ),
        pw.Align(
          alignment: pw.Alignment.bottomRight,
          child: pw.Text("Payable: $payable"),
        ),
        pw.Align(
          alignment: pw.Alignment.bottomRight,
          child: pw.Text("Payment: $payment"),
        ),
        pw.Align(
          alignment: pw.Alignment.bottomRight,
          child: pw.Text("balance: $balance"),
        )
      ],
    );
  }

  pw.Table printTable(pw.Context context, int number) {
    return pw.Table.fromTextArray(
        columnWidths: {
          0: const pw.FlexColumnWidth(2),
          1: const pw.FlexColumnWidth(5),
          2: const pw.FlexColumnWidth(5),
          3: const pw.FlexColumnWidth(3),
          4: const pw.FlexColumnWidth(5),
          5: const pw.FlexColumnWidth(5),
        },
        context: context,
        cellStyle: const pw.TextStyle(
          fontSize: pdfFont,
        ),
        headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
        data: <List<String>>[
          <String>["#", 'Item', 'Category', 'Qty', 'Price', 'Sub Total'],
          ...sd.map((e) => [
                (number = number + 1).toString(),
                e.service,
                e.sub,
                controller.productQuantity(e).toString(),
                Utils().formatPrice(e.price),
                Utils().formatPrice(
                    double.parse(e.price) * controller.productQuantity(e))
              ])
        ]);
  }

  pw.Padding invoiceLayer() {
    return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 0),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Invoice #: $invoiceID"),
              pw.Text("Customer: $customer "),
              pw.Text("Rep: $rep "),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Sales Date: $booking"),
                  pw.Text(DateTime.now().dateTimeFormatShortString())
                ],
              ),
            ]));
  }

  pw.Row printHeader(pw.ImageProvider image) {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
      pw.Align(
          alignment: pw.Alignment.topLeft,
          child: pw.SizedBox(
              height: 35,
              child: pw.Image(
                image,
              ))),
      pw.Center(
          child: pw.Column(children: [
        pw.SizedBox(
            child: pw.Text(Cpy.cpyName,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 16))),
        pw.SizedBox(
            child: pw.Text(Cpy.cpyContact,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9))),
        pw.SizedBox(
            child: pw.Text(Cpy.cpyGps,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9))),
        pw.Text("Email: ${Cpy.cpyEmail}",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
        pw.Text("Website: ${Cpy.cpyWebsite}",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
        pw.Text("Branch: $branch",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
        pw.SizedBox(width: 10),
      ])),
    ]);
  }
}

class ProformalReceipt {
  final BuildContext context;
  final POSCon controller;
  final List<dynamic> sd;
  final String invoiceID;
  final String customer;
  final String rep;
  final String? booking;
  final String branch;
  final String total;
  final String discount;
  final String payable;

  ProformalReceipt({
    required this.context,
    required this.sd,
    required this.branch,
    required this.controller,
    required this.invoiceID,
    required this.customer,
    required this.rep,
    required this.booking,
    required this.total,
    required this.discount,
    required this.payable,
  });

  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    int number = 0;
    final image = await imageFromAssetBundle('assets/icons/logo.png');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.portrait,
        margin: const pw.EdgeInsets.symmetric(horizontal: 10),
        build: (context) => [
          pw.Column(
            children: [
              printHeader(image),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text('Proforma Invoice',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 18)),
              ),
              pw.SizedBox(height: 10),
              invoiceLayer(),
              pw.SizedBox(
                height: 10,
              ),
              printTable(context, number),
              pw.SizedBox(
                height: 10,
              ),
              amountDetails(),
              pw.SizedBox(
                height: 20,
              ),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  "Thank you for doing business with us!",
                  //style: const pw.TextStyle(fontSize: 15)
                ),
              ),
              pw.SizedBox(
                height: 10,
              ),
              pw.Align(
                alignment: pw.Alignment.bottomLeft,
                child: pw.Text("Software by bistechgh.com"),
              )
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Column amountDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Align(
          alignment: pw.Alignment.bottomRight,
          child: pw.Text("Total: $total"),
        ),
        pw.Align(
          alignment: pw.Alignment.bottomRight,
          child: pw.Text("Discount: $discount"),
        ),
        pw.Align(
          alignment: pw.Alignment.bottomRight,
          child: pw.Text("Payable: $payable"),
        ),
      ],
    );
  }

  pw.Table printTable(pw.Context context, int number) {
    return pw.Table.fromTextArray(
        columnWidths: {
          0: const pw.FlexColumnWidth(2),
          1: const pw.FlexColumnWidth(5),
          2: const pw.FlexColumnWidth(5),
          3: const pw.FlexColumnWidth(3),
          4: const pw.FlexColumnWidth(5),
          5: const pw.FlexColumnWidth(5),
        },
        context: context,
        cellStyle: const pw.TextStyle(
          fontSize: pdfFont,
        ),
        headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
        data: <List<String>>[
          <String>["#", 'Item', 'Category', 'Qty', 'Price', 'Sub Total'],
          ...sd.map((e) => [
                (number = number + 1).toString(),
                e.service,
                e.sub,
                controller.productQuantity(e).toString(),
                Utils().formatPrice(e.price),
                Utils().formatPrice(
                    double.parse(e.price) * controller.productQuantity(e))
              ])
        ]);
  }

  pw.Padding invoiceLayer() {
    return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 0),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Invoice #: $invoiceID"),
              pw.Text("Customer: $customer "),
              pw.Text("Rep: $rep "),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Date: $booking"),
                  pw.Text(DateTime.now().dateTimeFormatShortString())
                ],
              ),
            ]));
  }

  pw.Row printHeader(pw.ImageProvider image) {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
      pw.Align(
          alignment: pw.Alignment.topLeft,
          child: pw.SizedBox(
              height: 35,
              child: pw.Image(
                image,
              ))),
      pw.Center(
          child: pw.Column(children: [
        pw.SizedBox(
            child: pw.Text(Cpy.cpyName,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 16))),
        pw.SizedBox(
            child: pw.Text(Cpy.cpyContact,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9))),
        pw.SizedBox(
            child: pw.Text(Cpy.cpyGps,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9))),
        pw.Text("Email: ${Cpy.cpyEmail}",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
        pw.Text("Website: ${Cpy.cpyWebsite}",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
        pw.Text("Branch: $branch",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
        pw.SizedBox(width: 10),
      ])),
    ]);
  }
}
