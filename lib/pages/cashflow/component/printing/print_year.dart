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

class YearCashflowPrint extends StatelessWidget {
  const YearCashflowPrint({
    Key? key,
    required this.title,
    required this.income,
    required this.cashBal,
    required this.expenses,
    required this.totalCashInflow,
    required this.totalCashOutflow,
    required this.endCash,
    required this.incomecashBalance,
    required this.netCash,
  }) : super(key: key);
  final List<YearCashModel> income;
  final List<YearCashModel> expenses;
  final List<SubCashYearModel> totalCashInflow;
  final List<SubCashYearModel> totalCashOutflow;

  final List<SubCashYearModel> cashBal;
  final List<SubCashYearModel> endCash;
  final List<SubCashYearModel> incomecashBalance;
  final List<SubCashYearModel> netCash;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "Cashflow Report".toLabel()),
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
              pw.Text(DateTime.now().dateTimeFormatShortString(),
                  style: const pw.TextStyle(fontSize: 12))
            ],
          ),
          cashBalance(context, cashBal),
          cashHeader(context, 'Cash Inflow'),
          for (int i = 0; i < income.length; i++)
            printTable(
                context, income[i].subList, income[i].name, income[i].subTotal),
          pw.SizedBox(
            height: 3,
          ),
          totalSum(context, "total cash inflow", totalCashInflow),
          totalNetSum(context, "available cash balance", incomecashBalance),
          pw.SizedBox(
            height: 5,
          ),
          cashHeader(context, 'Cash Outflow'),
          for (int i = 0; i < expenses.length; i++)
            printTable(context, expenses[i].subList, expenses[i].name,
                expenses[i].subTotal),
          totalSum(context, "total cash outflow", totalCashOutflow),
          pw.SizedBox(
            height: 3,
          ),
          totalSum(context, "net increase(decrease) in cash", netCash),
          totalNetSum(context, "ending cash balance", endCash),
          pw.SizedBox(
            height: 5,
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Table totalSum(
    pw.Context context,
    String title,
    List<SubCashYearModel> record,
  ) {
    return pw.Table.fromTextArray(
        columnWidths: {
          0: const pw.FixedColumnWidth(8),
          1: const pw.FixedColumnWidth(5),
          2: const pw.FixedColumnWidth(5),
          3: const pw.FixedColumnWidth(4),
          4: const pw.FixedColumnWidth(4),
          5: const pw.FixedColumnWidth(4),
          7: const pw.FixedColumnWidth(4),
          6: const pw.FixedColumnWidth(4),
          8: const pw.FixedColumnWidth(4),
          9: const pw.FixedColumnWidth(5),
          10: const pw.FixedColumnWidth(5),
          11: const pw.FixedColumnWidth(5),
          12: const pw.FixedColumnWidth(5),
          13: const pw.FixedColumnWidth(5),
        },
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerRight,
          2: pw.Alignment.centerRight,
          3: pw.Alignment.centerRight,
          4: pw.Alignment.centerRight,
          5: pw.Alignment.centerRight,
          6: pw.Alignment.centerRight,
          7: pw.Alignment.centerRight,
          8: pw.Alignment.centerRight,
          9: pw.Alignment.centerRight,
          10: pw.Alignment.centerRight,
          11: pw.Alignment.centerRight,
          12: pw.Alignment.centerRight,
          13: pw.Alignment.centerRight,
        },
        context: context,
        border: null,
        cellStyle: const pw.TextStyle(
          fontSize: pdfFont,
        ),
        headerDecoration: const pw.BoxDecoration(
          color: PdfColors.grey200,
        ),
        headerStyle: pw.TextStyle(
            fontSize: pdfFontHeader, fontWeight: pw.FontWeight.bold),
        data: <List<String>>[
          ...record.map((e) => [
                title.toUpperCase(),
                Utils().formatPrice(e.jan),
                Utils().formatPrice(e.feb),
                Utils().formatPrice(e.mar),
                Utils().formatPrice(e.apirl),
                Utils().formatPrice(e.may),
                Utils().formatPrice(e.june),
                Utils().formatPrice(e.july),
                Utils().formatPrice(e.aug),
                Utils().formatPrice(e.sep),
                Utils().formatPrice(e.oct),
                Utils().formatPrice(e.nov),
                Utils().formatPrice(e.dec),
                Utils().formatPrice(double.parse(e.jan) +
                    double.parse(e.feb) +
                    double.parse(e.mar) +
                    double.parse(e.apirl) +
                    double.parse(e.june) +
                    double.parse(e.july) +
                    double.parse(e.aug) +
                    double.parse(e.sep) +
                    double.parse(e.oct) +
                    double.parse(e.nov) +
                    double.parse(e.dec) +
                    double.parse(e.may))
              ])
        ]);
  }

  pw.Table totalNetSum(
    pw.Context context,
    String title,
    List<SubCashYearModel> record,
  ) {
    return pw.Table.fromTextArray(
        columnWidths: {
          0: const pw.FixedColumnWidth(8),
          1: const pw.FixedColumnWidth(5),
          2: const pw.FixedColumnWidth(5),
          3: const pw.FixedColumnWidth(4),
          4: const pw.FixedColumnWidth(4),
          5: const pw.FixedColumnWidth(4),
          7: const pw.FixedColumnWidth(4),
          6: const pw.FixedColumnWidth(4),
          8: const pw.FixedColumnWidth(4),
          9: const pw.FixedColumnWidth(5),
          10: const pw.FixedColumnWidth(5),
          11: const pw.FixedColumnWidth(5),
          12: const pw.FixedColumnWidth(5),
          13: const pw.FixedColumnWidth(5),
        },
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerRight,
          2: pw.Alignment.centerRight,
          3: pw.Alignment.centerRight,
          4: pw.Alignment.centerRight,
          5: pw.Alignment.centerRight,
          6: pw.Alignment.centerRight,
          7: pw.Alignment.centerRight,
          8: pw.Alignment.centerRight,
          9: pw.Alignment.centerRight,
          10: pw.Alignment.centerRight,
          11: pw.Alignment.centerRight,
          12: pw.Alignment.centerRight,
          13: pw.Alignment.centerRight,
        },
        context: context,
        border: null,
        cellStyle: const pw.TextStyle(
          fontSize: pdfFont,
        ),
        headerDecoration: const pw.BoxDecoration(
          color: PdfColors.grey400,
        ),
        headerStyle: pw.TextStyle(
            fontSize: pdfFontHeader, fontWeight: pw.FontWeight.bold),
        data: <List<String>>[
          ...record.map((e) => [
                title.toUpperCase(),
                Utils().formatPrice(e.jan),
                Utils().formatPrice(e.feb),
                Utils().formatPrice(e.mar),
                Utils().formatPrice(e.apirl),
                Utils().formatPrice(e.may),
                Utils().formatPrice(e.june),
                Utils().formatPrice(e.july),
                Utils().formatPrice(e.aug),
                Utils().formatPrice(e.sep),
                Utils().formatPrice(e.oct),
                Utils().formatPrice(e.nov),
                Utils().formatPrice(e.dec),
                ''
              ])
        ]);
  }

  pw.Table cashBalance(
    pw.Context context,
    List<SubCashYearModel> record,
  ) {
    return pw.Table.fromTextArray(
        columnWidths: {
          0: const pw.FixedColumnWidth(8),
          1: const pw.FixedColumnWidth(5),
          2: const pw.FixedColumnWidth(5),
          3: const pw.FixedColumnWidth(4),
          4: const pw.FixedColumnWidth(4),
          5: const pw.FixedColumnWidth(4),
          7: const pw.FixedColumnWidth(4),
          6: const pw.FixedColumnWidth(4),
          8: const pw.FixedColumnWidth(4),
          9: const pw.FixedColumnWidth(5),
          10: const pw.FixedColumnWidth(5),
          11: const pw.FixedColumnWidth(5),
          12: const pw.FixedColumnWidth(5),
          13: const pw.FixedColumnWidth(5),
        },
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerRight,
          2: pw.Alignment.centerRight,
          3: pw.Alignment.centerRight,
          4: pw.Alignment.centerRight,
          5: pw.Alignment.centerRight,
          6: pw.Alignment.centerRight,
          7: pw.Alignment.centerRight,
          8: pw.Alignment.centerRight,
          9: pw.Alignment.centerRight,
          10: pw.Alignment.centerRight,
          11: pw.Alignment.centerRight,
          12: pw.Alignment.centerRight,
          13: pw.Alignment.centerRight,
        },
        context: context,
        border: null,
        cellStyle: const pw.TextStyle(
          fontSize: pdfFont,
        ),
        headerDecoration: const pw.BoxDecoration(
          color: PdfColors.grey400,
        ),
        headerStyle: pw.TextStyle(
            fontSize: pdfFontHeader, fontWeight: pw.FontWeight.bold),
        data: <List<String>>[
          <String>[
            ' ',
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December',
            "Total"
          ],
          ...record.map((e) => [
                "Beginning Cash Balance".toUpperCase(),
                Utils().formatPrice(e.jan),
                Utils().formatPrice(e.feb),
                Utils().formatPrice(e.mar),
                Utils().formatPrice(e.apirl),
                Utils().formatPrice(e.may),
                Utils().formatPrice(e.june),
                Utils().formatPrice(e.july),
                Utils().formatPrice(e.aug),
                Utils().formatPrice(e.sep),
                Utils().formatPrice(e.oct),
                Utils().formatPrice(e.nov),
                Utils().formatPrice(e.dec),
              ])
        ]);
  }

  pw.Table cashHeader(pw.Context context, String title) {
    return pw.Table.fromTextArray(
        columnWidths: {
          0: const pw.FixedColumnWidth(8),
          1: const pw.FixedColumnWidth(5),
          2: const pw.FixedColumnWidth(5),
          3: const pw.FixedColumnWidth(4),
          4: const pw.FixedColumnWidth(4),
          5: const pw.FixedColumnWidth(4),
          7: const pw.FixedColumnWidth(4),
          6: const pw.FixedColumnWidth(4),
          8: const pw.FixedColumnWidth(4),
          9: const pw.FixedColumnWidth(5),
          10: const pw.FixedColumnWidth(5),
          11: const pw.FixedColumnWidth(5),
          12: const pw.FixedColumnWidth(5),
          13: const pw.FixedColumnWidth(5),
        },
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerRight,
          2: pw.Alignment.centerRight,
          3: pw.Alignment.centerRight,
          4: pw.Alignment.centerRight,
          5: pw.Alignment.centerRight,
          6: pw.Alignment.centerRight,
          7: pw.Alignment.centerRight,
          8: pw.Alignment.centerRight,
          9: pw.Alignment.centerRight,
          10: pw.Alignment.centerRight,
          11: pw.Alignment.centerRight,
          12: pw.Alignment.centerRight,
          13: pw.Alignment.centerRight,
        },
        context: context,
        border: null,
        cellStyle: const pw.TextStyle(
          fontSize: pdfFont,
        ),
        headerDecoration: const pw.BoxDecoration(
          color: PdfColors.grey400,
        ),
        headerStyle: pw.TextStyle(
            fontSize: pdfFontHeader, fontWeight: pw.FontWeight.bold),
        data: <List<String>>[
          <String>[
            title,
            '',
            '',
            '',
            '',
            '',
            '',
          ],
        ]);
  }

  pw.Column printTable(pw.Context context, List<SubYearCashModel> subList,
      String title, List<SubCashYearModel> subTotal) {
    return pw.Column(
      children: [
        pw.Table.fromTextArray(
            columnWidths: {
              0: const pw.FixedColumnWidth(8),
              1: const pw.FixedColumnWidth(5),
              2: const pw.FixedColumnWidth(5),
              3: const pw.FixedColumnWidth(4),
              4: const pw.FixedColumnWidth(4),
              5: const pw.FixedColumnWidth(4),
              7: const pw.FixedColumnWidth(4),
              6: const pw.FixedColumnWidth(4),
              8: const pw.FixedColumnWidth(4),
              9: const pw.FixedColumnWidth(5),
              10: const pw.FixedColumnWidth(5),
              11: const pw.FixedColumnWidth(5),
              12: const pw.FixedColumnWidth(5),
              13: const pw.FixedColumnWidth(5),
            },
            cellAlignments: {
              0: pw.Alignment.centerLeft,
            },
            context: context,
            border: null,
            cellStyle: const pw.TextStyle(
              fontSize: pdfFont,
            ),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.grey300,
            ),
            headerStyle: pw.TextStyle(
                fontSize: pdfFontHeader, fontWeight: pw.FontWeight.bold),
            data: <List<String>>[
              <String>[
                title,
                '',
                '',
                '',
                '',
                '',
              ],
            ]),
        pw.Table.fromTextArray(
            columnWidths: {
              0: const pw.FixedColumnWidth(8),
              1: const pw.FixedColumnWidth(5),
              2: const pw.FixedColumnWidth(5),
              3: const pw.FixedColumnWidth(4),
              4: const pw.FixedColumnWidth(4),
              5: const pw.FixedColumnWidth(4),
              7: const pw.FixedColumnWidth(4),
              6: const pw.FixedColumnWidth(4),
              8: const pw.FixedColumnWidth(4),
              9: const pw.FixedColumnWidth(5),
              10: const pw.FixedColumnWidth(5),
              11: const pw.FixedColumnWidth(5),
              12: const pw.FixedColumnWidth(5),
              13: const pw.FixedColumnWidth(5),
            },
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerRight,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
              5: pw.Alignment.centerRight,
              6: pw.Alignment.centerRight,
              7: pw.Alignment.centerRight,
              8: pw.Alignment.centerRight,
              9: pw.Alignment.centerRight,
              10: pw.Alignment.centerRight,
              11: pw.Alignment.centerRight,
              12: pw.Alignment.centerRight,
              13: pw.Alignment.centerRight,
            },
            context: context,
            border: null,
            cellStyle: const pw.TextStyle(
              fontSize: pdfFont,
            ),
            data: <List<String>>[
              <String>[
                ' ',
                '',
                '',
                '',
                '',
                '',
                '',
              ],
              ...subList.map(
                (e) => [
                  e.name,
                  Utils().formatPrice(e.jan),
                  Utils().formatPrice(e.feb),
                  Utils().formatPrice(e.mar),
                  Utils().formatPrice(e.apirl),
                  Utils().formatPrice(e.may),
                  Utils().formatPrice(e.june),
                  Utils().formatPrice(e.july),
                  Utils().formatPrice(e.aug),
                  Utils().formatPrice(e.sep),
                  Utils().formatPrice(e.oct),
                  Utils().formatPrice(e.nov),
                  Utils().formatPrice(e.dec),
                  Utils()
                      .formatPrice(double.parse(e.jan) +
                          double.parse(e.feb) +
                          double.parse(e.mar) +
                          double.parse(e.apirl) +
                          double.parse(e.june) +
                          double.parse(e.july) +
                          double.parse(e.aug) +
                          double.parse(e.sep) +
                          double.parse(e.oct) +
                          double.parse(e.nov) +
                          double.parse(e.dec) +
                          double.parse(e.may))
                      .toString()
                ],
              ),
            ]),
        pw.Table.fromTextArray(
            columnWidths: {
              0: const pw.FixedColumnWidth(8),
              1: const pw.FixedColumnWidth(5),
              2: const pw.FixedColumnWidth(5),
              3: const pw.FixedColumnWidth(4),
              4: const pw.FixedColumnWidth(4),
              5: const pw.FixedColumnWidth(4),
              7: const pw.FixedColumnWidth(4),
              6: const pw.FixedColumnWidth(4),
              8: const pw.FixedColumnWidth(4),
              9: const pw.FixedColumnWidth(5),
              10: const pw.FixedColumnWidth(5),
              11: const pw.FixedColumnWidth(5),
              12: const pw.FixedColumnWidth(5),
              13: const pw.FixedColumnWidth(5),
            },
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerRight,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
              5: pw.Alignment.centerRight,
              6: pw.Alignment.centerRight,
              7: pw.Alignment.centerRight,
              8: pw.Alignment.centerRight,
              9: pw.Alignment.centerRight,
              10: pw.Alignment.centerRight,
              11: pw.Alignment.centerRight,
              12: pw.Alignment.centerRight,
              13: pw.Alignment.centerRight,
            },
            context: context,
            border: null,
            cellStyle: const pw.TextStyle(
              fontSize: pdfFont,
            ),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.grey200,
            ),
            headerStyle: pw.TextStyle(
                fontSize: pdfFontHeader, fontWeight: pw.FontWeight.bold),
            data: <List<String>>[
              ...subTotal.map(
                (e) => [
                  "$title Total",
                  Utils().formatPrice(e.jan),
                  Utils().formatPrice(e.feb),
                  Utils().formatPrice(e.mar),
                  Utils().formatPrice(e.apirl),
                  Utils().formatPrice(e.may),
                  Utils().formatPrice(e.june),
                  Utils().formatPrice(e.july),
                  Utils().formatPrice(e.aug),
                  Utils().formatPrice(e.sep),
                  Utils().formatPrice(e.oct),
                  Utils().formatPrice(e.nov),
                  Utils().formatPrice(e.dec),
                  Utils()
                      .formatPrice(double.parse(e.jan) +
                          double.parse(e.feb) +
                          double.parse(e.mar) +
                          double.parse(e.apirl) +
                          double.parse(e.june) +
                          double.parse(e.july) +
                          double.parse(e.aug) +
                          double.parse(e.sep) +
                          double.parse(e.oct) +
                          double.parse(e.nov) +
                          double.parse(e.dec) +
                          double.parse(e.may))
                      .toString()
                ],
              ),
            ])
      ],
    );
  }
}
