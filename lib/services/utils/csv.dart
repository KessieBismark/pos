// import 'dart:html';

// import 'package:csv/csv.dart';

// class ExportCsv {
//   final List data;
//   ExportCsv({this.data});

//   List<List<dynamic>> rows = <List<dynamic>>[];
//   downloadData() {
//     for (int i = 0; i < data.length; i++) {
//       List<dynamic> row = [];
//       row.add(data[i].userName);
//       row.add(data[i].userLastName);
//       row.add(data[i].userEmail);
//       rows.add(row);
//     }

//     String csv = const ListToCsvConverter().convert(rows);
//     AnchorElement(href: "data:text/plain;charset=utf-8,$csv")
//       ..setAttribute("download", "data.csv")
//       ..click();
//   }
// }
