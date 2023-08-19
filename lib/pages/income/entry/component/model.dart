class InModel {
  final String id;

  final dynamic date;
  final String sub;
  final String cat;
  final dynamic amount;
  final String? des;
  final String type;
  final String? cheque;
  final dynamic entryDate;
  final String branch;

  InModel(
      {required this.id,
      required this.date,
      required this.cat,
      required this.sub,
      required this.amount,
      this.des,
      required this.type,
      required this.branch,
      this.cheque,
      required this.entryDate});

  factory InModel.fromJson(Map<String, dynamic> map) {
    return InModel(
        id: map['id'],
        date: map['date'],
        amount:double.parse( map['amount']),
        cat: map['category'],
        des: map['description'] ?? '',
        sub: map['sub_category'],
        type: map['type'],
        branch: map['branch'],
        cheque: map['cheque_no'] ?? '',
        entryDate: map['entry_date']);
  }
}

class CloseSales {
  final String year;
  final String month;

  CloseSales({required this.year, required this.month});

  factory CloseSales.fromJson(Map<String, dynamic> map) {
    return CloseSales(year: map['year'], month: map['month']);
  }
}
