class EModel {
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

  EModel(
      {required this.id,
      required this.date,
      required this.cat,
      required this.sub,
      required this.amount,
      required this.branch,
      this.des,
      required this.type,
      this.cheque,
      required this.entryDate});

  factory EModel.fromJson(Map<String, dynamic> map) {
    return EModel(
        id: map['id'],
        date: map['date'],
        amount: double.parse(map['amount']),
        cat: map['category'],
        des: map['description'] ?? '',
        sub: map['sub_category'],
        branch: map['branch'],
        type: map['type'],
        cheque: map['cheque_no'] ?? '',
        entryDate: map['entry_date']);
  }
}
