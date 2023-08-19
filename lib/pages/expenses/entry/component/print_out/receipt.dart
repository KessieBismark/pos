import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../../services/utils/company_details.dart';
import '../../../../../services/utils/helpers.dart';
import '../../../../../services/widgets/extension.dart';

class ExpensesReceipt extends StatelessWidget {
  const ExpensesReceipt(
      {Key? key,
      required this.title,
      required this.type,
      required this.amount,
      required this.branch,
      required this.category,
      this.cheque,
      this.des,
      required this.invoice,
      required this.date})
      : super(key: key);

  final String title;
  final String type;
  final DateTime date;
  final dynamic amount;
  final String branch;
  final String? des;
  final String category;
  final String? cheque;
  final String invoice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "Target Report".toLabel()),
      body: PdfPreview(
        build: (format) => _generatePdf(title),
      ),
    );
  }

  Future<Uint8List> _generatePdf(String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final image = await imageFromAssetBundle('assets/icons/logo.png');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.portrait,
        build: (context) => [
          pw.Container(
            decoration: pw.BoxDecoration(border: pw.Border.all(width: 1.0)),
            child: pw.Column(
              children: [
                printHeader(image),
                pw.SizedBox(height: 10),
                pw.Center(
                    child: pw.SizedBox(child: pw.Text(title.toUpperCase()))),
                invoiceLayer(),
                pw.Padding(
                    padding: const pw.EdgeInsets.only(top: -9),
                    child: pw.Divider()),
                cashPayment(),
                pw.SizedBox(
                  height: 20,
                ),
                paymentType(),
                pw.SizedBox(
                  height: 5,
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        cheque == null ? pw.Text("Cheque #: ") : pw.Container(),
                        pw.Text("Received Date: ${date.dateFormatString()}"),
                      ]),
                ),
                pw.SizedBox(
                  height: 5,
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                  child: pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text("Description: ${des!.capitalizeFirst}")),
                ),
                pw.SizedBox(
                  height: 20,
                ),
                payedBy(),
                pw.SizedBox(
                  height: 20,
                ),
                approvedBy(),
                pw.SizedBox(
                  height: 10,
                )
              ],
            ),
          )
        ],
      ),
    );

    return pdf.save();
  }

  pw.Padding payedBy() {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text("Payed by:      ______________________"),
          pw.Text("Signature: _________________"),
        ],
      ),
    );
  }

  pw.Padding approvedBy() {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text("Received by: ______________________"),
          pw.Text("Signature: _________________"),
        ],
      ),
    );
  }

  pw.Padding paymentType() {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [pw.Text("Payment type: $type"), pw.Text("Branch: $branch")],
      ),
    );
  }

  pw.Padding cashPayment() {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text("Credit payment of (GHC): ${Utils().formatPrice(amount)}"),
          pw.Text("Category: $category"),
        ],
      ),
    );
  }

  pw.Padding invoiceLayer() {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text("Invoice #: $invoice"),
          pw.Text(DateTime.now().dateTimeFormatShortString())
        ],
      ),
    );
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
        pw.SizedBox(width: 10),
      ])),
    ]);
  }
}






// class DirectPrint{
//    void printInvoice() async {
//     final invoice = Invoice(
//         supplier: Shop(
//           name: 'Sarah Field',
//           address: 'Sarah Street 9, Beijing, China',
//           contact: 'https://paypal.me/sarahfieldzz',
//         ),
//         info: InvoiceData(
//           invoiceNo: _invoiceno,
//           rep: _rep,
//           client: _client,
//           issuedDate: _issueddate,
//           payment: _payment,
//           balance: _balance,
//           totalAmount: _totalamount,
//           tax: _tax,
//           discount: _discount,
//           refund: _refund,
//           finalAmount: _finalAmount,
//         ),
//         items: [
//           for (var list in _products)
//             InvoiceItem(
//                 productName: list.productName,
//                 quantity: list.quantity,
//                 itemPrice: list.itemPrice,
//                 itemTotalPrice: list.itemTotalPrice)
//         ]);
//     try {
//       final pdfFile = await PdfInvoiceApi.generate(invoice);

//       PdfApi.openFile(pdfFile);
//     } catch (e) {
//       print(e);
//     }
//   }
// }

// }