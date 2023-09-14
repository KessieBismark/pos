import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../services/constants/constant.dart';
import '../../../../services/utils/company_details.dart';
import '../../../../services/utils/helpers.dart';
import '../model.dart';

class SalesReceipt {
  final BuildContext context;
  final List<SDModel> sd;
  final String invoiceID;
  final String customer;
  final String rep;
  final String? booking;
  final String branch;
  final dynamic total;
  final dynamic discount;
  final dynamic payable;
  final dynamic payment;
  final dynamic balance;

  SalesReceipt(
      {required this.context,
      required this.branch,
      required this.sd,
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
        pageFormat: PdfPageFormat.a4.portrait,
        build: (context) => [
          pw.Column(
            children: [
              printHeader(image),
              pw.SizedBox(height: 20),
              payment >= payable
                  ? pw.Text("Proforma Receipt: Paid",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                  : pw.Text("Proforma Receipt: Unpaid",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              invoiceLayer(),
              pw.SizedBox(
                height: 20,
              ),
              printTable(context, number),
              pw.SizedBox(
                height: 20,
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.bottomRight,
                    child: pw.Text("Total: ${Utils().formatPrice(total)}"),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.bottomRight,
                    child:
                        pw.Text("Dsicount: ${Utils().formatPrice(discount)}"),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.bottomRight,
                    child: pw.Text("Payable: ${Utils().formatPrice(payable)}"),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.bottomRight,
                    child: pw.Text("Payment: ${Utils().formatPrice(payment)}"),
                  ),
                  pw.Align(
                    alignment: pw.Alignment.bottomRight,
                    child: pw.Text("balance: ${Utils().formatPrice(balance)}"),
                  )
                ],
              ),
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
        ...sd.map(
          (e) => [
            (number = number + 1).toString(),
            e.service,
              e.cat,
                e.qty,
                Utils().formatPrice(e.price),
                Utils().formatPrice(e.subTotal)
          ],
        )
      ],
    );
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
        ],
      ),
    );
  }

  pw.Row printHeader(pw.ImageProvider image) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.Align(
          alignment: pw.Alignment.topLeft,
          child: pw.SizedBox(
            height: 35,
            child: pw.Image(
              image,
            ),
          ),
        ),
        pw.Center(
          child: pw.Column(
            children: [
              pw.SizedBox(
                  child: pw.Text(Cpy.cpyName,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 16))),
              pw.SizedBox(
                  child: pw.Text(Cpy.cpyContact,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 9))),
              pw.SizedBox(
                  child: pw.Text(Cpy.cpyGps,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 9))),
              pw.Text("Email: ${Cpy.cpyEmail}",
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 9)),
              pw.Text("Website: ${Cpy.cpyWebsite}",
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 9)),
              pw.Text("Branch: $branch",
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 9)),
              pw.SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }
}
