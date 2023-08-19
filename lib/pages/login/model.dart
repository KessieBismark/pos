class AlertModel {
  final String id;
  final String name;
  final String pnet;
  final String issue;
  final String reOrder;

  AlertModel({
    required this.id,
    required this.name,
    required this.pnet,
    required this.issue,
    required this.reOrder,
  });

  factory AlertModel.fromJson(Map<String, dynamic> map) {
    return AlertModel(
        id: map['id'],
        name: map['name'],
        pnet: map['pnet'],
        issue: map['issue'],
        reOrder: map['re_order']);
  }
}
