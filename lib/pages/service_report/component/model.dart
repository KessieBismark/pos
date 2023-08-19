class SRModel {
  final String id;
  final dynamic total;
  final dynamic payable;
  final dynamic payment;
  final dynamic balance;
  final dynamic discount;
  final String rep;
  final String customer;
  final String branch;
  final String date;
  final String book;

  SRModel(
      {required this.id,
      required this.book,
      required this.total,
      required this.payable,
      required this.payment,
      required this.balance,
      required this.discount,
      required this.rep,
      required this.customer,
      required this.branch,
      required this.date});

  factory SRModel.fromJson(Map<String, dynamic> map) {
    return SRModel(
        id: map['id'],
        book: map['book'],
        total: map['total'],
        payable: map['payable'],
        payment: map['payment'],
        balance: map['balance'],
        discount: map['discount'],
        rep: map['rep'],
        customer: map['customer'],
        branch: map['branch'],
        date: map['date']);
  }
}

class SDModel {
  final String service;
  final String cat;
  final dynamic price;
  final String qty;
  final String subTotal;

  SDModel({
    required this.service,
    required this.cat,
    required this.price,
    required this.qty,
    required this.subTotal,
  });

  factory SDModel.fromJson(Map<String, dynamic> map) {
    return SDModel(
        service: map['service'],
        price: map['price'],
        cat: map['cat'],
        qty: map['quantity'],
        subTotal: map['sub_total']);
  }
}
