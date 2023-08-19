import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../../services/constants/constant.dart';
import '../../../../../services/utils/company_details.dart';
import '../../../../../services/utils/helpers.dart';
import '../../../../../services/widgets/extension.dart';
import '../model.dart';

class IncomePrint extends StatelessWidget {
  const IncomePrint(
      {Key? key, required this.attendanceList, required this.title})
      : super(key: key);
  final List<InModel> attendanceList;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "Income Report".toLabel()),
      body: PdfPreview(
        build: (format) => _generatePdf(title),
      ),
    );
  }

  Future<Uint8List> _generatePdf(String title) async {
    int number = 0;

    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final image = await imageFromAssetBundle('assets/icons/logo.png');
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
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
              pw.SizedBox(width: 10),
            ])),
          ]),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.SizedBox(child: pw.Text(title.toUpperCase())),
              pw.Text(DateTime.now().dateTimeFormatShortString())
            ],
          ),
          pw.Table.fromTextArray(
              columnWidths: const {
                0: pw.FlexColumnWidth(3),
                1: pw.FlexColumnWidth(6),
                2: pw.FlexColumnWidth(6),
                3: pw.FlexColumnWidth(6),
                4: pw.FlexColumnWidth(5),
                5: pw.FlexColumnWidth(8),
                6: pw.FlexColumnWidth(4),
                7: pw.FlexColumnWidth(4),
                8: pw.FlexColumnWidth(6),
                9: pw.FlexColumnWidth(6),
              },
              context: context,
              cellStyle: const pw.TextStyle(
                fontSize: pdfFont,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              data: <List<String>>[
                <String>[
                  '#',
                  'Category',
                  'Sub Category',
                  'Amount',
                  'Branch',
                  'Description',
                  'Date',
                  'Type',
                  'Cheque #',
                  'Entry date',
                ],
                ...attendanceList.map(
                  (data) => [
                    (number = number + 1).toString(),
                    data.cat,
                    data.sub,
                    Utils().formatPrice(data.amount),
                    data.branch,
                    data.des!,
                    data.date,
                    data.type,
                    data.cheque!,
                    data.entryDate,
                  ],
                ),
              ]),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Spacer(),
              pw.Text("Total: "),
              pw.Text(Utils().formatPrice(attendanceList
                  .map((e) => e.amount)
                  .reduce((value, element) =>  value + element)).toString())
            ],
          )
        ],
      ),
    );

    return pdf.save();
  }
}
