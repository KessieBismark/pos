class FastSMondel {
  final String name;
  final String count;

  FastSMondel({required this.name, required this.count});

  factory FastSMondel.fromJson(Map<String, dynamic> map) {
    return FastSMondel(name: map['name'], count: map['count']);
  }
}

class NetProfitModel {
  final dynamic name;
  final dynamic value;

  NetProfitModel({required this.name, required this.value});

  factory NetProfitModel.fromJson(Map<String, dynamic> map) {
    return NetProfitModel(name: map['name'], value: map['value']);
  }
}

class ActModelT {
  final String name;
  final double amount;

  ActModelT({required this.name, required this.amount});

  factory ActModelT.fromJson(Map<String, dynamic> map) {
    return ActModelT(name: map['name'], amount: double.parse(map['amount']));
  }
}

class ActModel {
  final dynamic name;
  final dynamic amount;

  ActModel({required this.name, required this.amount});

  factory ActModel.fromJson(Map<String, dynamic> map) {
    return ActModel(name: map['month'], amount: map['amount']);
  }
}
