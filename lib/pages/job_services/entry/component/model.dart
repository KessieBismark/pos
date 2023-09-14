class ServiceModel {
  final String id;
  final String name;
  final String sub;
  final String cat;
  final String? des;
  final String bid;
  final String? quantity;
  final dynamic price;
  final dynamic cost;
  final String branch;

  ServiceModel(
      {required this.id,
      required this.name,
      required this.sub,
      required this.cat,
      required this.bid,
      this.des,
      required this.quantity,
      required this.branch,
      required this.price,
      required this.cost});

  factory ServiceModel.fromJson(Map<String, dynamic> map) {
    return ServiceModel(
        id: map['id'],
        name: map['name'],
        cat: map['category'],
        sub: map['sub_category'],
        bid: map['bid'],
        branch: map['branch'],
        des: map['description'] ?? '',
        quantity: map['quantity'] ?? '',
        price: map['unit_price'],
        cost: map['cost']);
  }
}
