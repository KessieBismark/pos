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

class CashflowPrint extends StatelessWidget {
  const CashflowPrint({
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
  final List<MonthCashModel> income;
  final List<MonthCashModel> expenses;
  final List<SubCashModel> totalCashInflow;
  final List<SubCashModel> totalCashOutflow;

  final List<SubCashModel> cashBal;
  final List<SubCashModel> endCash;
  final List<SubCashModel> incomecashBalance;
  final List<SubCashModel> netCash;
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
        pageFormat: PdfPageFormat.a4.portrait,
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
          totalSum(
              context, "net increase(decrease) in cash", netCash),
               totalNetSum(
              context, "ending cash balance", endCash),
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
    List<SubCashModel> record,
  ) {
    return pw.Table.fromTextArray(
        columnWidths: {
          0: const pw.FlexColumnWidth(8),
          1: const pw.FlexColumnWidth(4),
          2: const pw.FlexColumnWidth(4),
          3: const pw.FlexColumnWidth(4),
          4: const pw.FlexColumnWidth(4),
          5: const pw.FlexColumnWidth(4),
          6: const pw.FlexColumnWidth(4),
        },
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerRight,
          2: pw.Alignment.centerRight,
          3: pw.Alignment.centerRight,
          4: pw.Alignment.centerRight,
          5: pw.Alignment.centerRight,
          6: pw.Alignment.centerRight,
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
                Utils().formatPrice(e.firstWeek),
                Utils().formatPrice(e.secWeek),
                Utils().formatPrice(e.thirdWeek),
                Utils().formatPrice(e.fouthWeek),
                Utils().formatPrice(e.fiveWeek),
                Utils().formatPrice( double.parse( e.firstWeek) +
                  double.parse(   e.secWeek )+
                  double.parse(   e.thirdWeek )+
                  double.parse(   e.fouthWeek) +
                  double.parse(   e.fiveWeek))
              ])
        ]);
  }

  pw.Table totalNetSum(
    pw.Context context,
    String title,
    List<SubCashModel> record,
  ) {
    return pw.Table.fromTextArray(
        columnWidths: {
          0: const pw.FlexColumnWidth(8),
          1: const pw.FlexColumnWidth(4),
          2: const pw.FlexColumnWidth(4),
          3: const pw.FlexColumnWidth(4),
          4: const pw.FlexColumnWidth(4),
          5: const pw.FlexColumnWidth(4),
          6: const pw.FlexColumnWidth(4),
        },
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerRight,
          2: pw.Alignment.centerRight,
          3: pw.Alignment.centerRight,
          4: pw.Alignment.centerRight,
          5: pw.Alignment.centerRight,
          6: pw.Alignment.centerRight,
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
                Utils().formatPrice(e.firstWeek),
                Utils().formatPrice(e.secWeek),
                Utils().formatPrice(e.thirdWeek),
                Utils().formatPrice(e.fouthWeek),
                Utils().formatPrice(e.fiveWeek),
                ''
              ])
        ]);
  }

  pw.Table cashBalance(
    pw.Context context,
    List<SubCashModel> record,
  ) {
    return pw.Table.fromTextArray(
        columnWidths: {
          0: const pw.FlexColumnWidth(8),
          1: const pw.FlexColumnWidth(4),
          2: const pw.FlexColumnWidth(4),
          3: const pw.FlexColumnWidth(4),
          4: const pw.FlexColumnWidth(4),
          5: const pw.FlexColumnWidth(4),
          6: const pw.FlexColumnWidth(4),
        },
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerRight,
          2: pw.Alignment.centerRight,
          3: pw.Alignment.centerRight,
          4: pw.Alignment.centerRight,
          5: pw.Alignment.centerRight,
          6: pw.Alignment.centerRight,
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
            'Week 1',
            'week 2',
            'Week 3',
            'Week 4',
            'Week 5',
            'Total',
          ],
          ...record.map((e) => [
                "Beginning Cash Balance".toUpperCase(),
                Utils().formatPrice(e.firstWeek),
                Utils().formatPrice(e.secWeek),
                Utils().formatPrice(e.thirdWeek),
                Utils().formatPrice(e.fouthWeek),
                Utils().formatPrice(e.fiveWeek)
              ])
        ]);
  }

  pw.Table cashHeader(pw.Context context, String title) {
    return pw.Table.fromTextArray(
        columnWidths: {
          0: const pw.FlexColumnWidth(8),
          1: const pw.FlexColumnWidth(4),
          2: const pw.FlexColumnWidth(4),
          3: const pw.FlexColumnWidth(4),
          4: const pw.FlexColumnWidth(4),
          5: const pw.FlexColumnWidth(4),
          6: const pw.FlexColumnWidth(4),
        },
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerRight,
          2: pw.Alignment.centerRight,
          3: pw.Alignment.centerRight,
          4: pw.Alignment.centerRight,
          5: pw.Alignment.centerRight,
          6: pw.Alignment.centerRight,
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

  pw.Column printTable(pw.Context context, List<SubMonthCashModel> subList,
      String title, List<SubCashModel> subTotal) {
    return pw.Column(
      children: [
        pw.Table.fromTextArray(
            columnWidths: {
              0: const pw.FlexColumnWidth(8),
              1: const pw.FlexColumnWidth(4),
              2: const pw.FlexColumnWidth(4),
              3: const pw.FlexColumnWidth(4),
              4: const pw.FlexColumnWidth(4),
              5: const pw.FlexColumnWidth(4),
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
              0: const pw.FlexColumnWidth(8),
              1: const pw.FlexColumnWidth(4),
              2: const pw.FlexColumnWidth(4),
              3: const pw.FlexColumnWidth(4),
              4: const pw.FlexColumnWidth(4),
              5: const pw.FlexColumnWidth(4),
              6: const pw.FlexColumnWidth(4),
            },
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerRight,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
              5: pw.Alignment.centerRight,
              6: pw.Alignment.centerRight,
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
                (data) => [
                  data.name,
                  Utils().formatPrice(data.firstWeek).toString(),
                  Utils().formatPrice(data.secWeek).toString(),
                  Utils().formatPrice(data.thirdWeek).toString(),
                  Utils().formatPrice(data.fouthWeek).toString(),
                  Utils().formatPrice(data.fiveWeek).toString(),
                  Utils()
                      .formatPrice((double.parse( data.firstWeek) +
                       double.parse(    data.secWeek )+
                       double.parse(    data.thirdWeek) +
                       double.parse(    data.fouthWeek )+
                       double.parse(    data.fiveWeek)))
                      .toString()
                ],
              ),
            ]),
        pw.Table.fromTextArray(
            columnWidths: {
              0: const pw.FlexColumnWidth(8),
              1: const pw.FlexColumnWidth(4),
              2: const pw.FlexColumnWidth(4),
              3: const pw.FlexColumnWidth(4),
              4: const pw.FlexColumnWidth(4),
              5: const pw.FlexColumnWidth(4),
              6: const pw.FlexColumnWidth(4),
            },
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerRight,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
              5: pw.Alignment.centerRight,
              6: pw.Alignment.centerRight,
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
                (data) => [
                  "$title Total",
                  Utils().formatPrice(data.firstWeek).toString(),
                  Utils().formatPrice(data.secWeek).toString(),
                  Utils().formatPrice(data.thirdWeek).toString(),
                  Utils().formatPrice(data.fouthWeek).toString(),
                  Utils().formatPrice(data.fiveWeek).toString(),
                  Utils()
                      .formatPrice((double.parse(  data.firstWeek )+
                        double.parse(   data.secWeek) +
                        double.parse(   data.thirdWeek) +
                        double.parse(   data.fouthWeek) +
                         double.parse(  data.fiveWeek)))
                      .toString()
                ],
              ),
            ])
      ],
    );
  }
}
