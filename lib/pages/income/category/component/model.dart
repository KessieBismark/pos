class InCatModel {
  final String id;
  final String name;
  final String? des;

  InCatModel({required this.id, required this.name, this.des});

  factory InCatModel.fromJson(Map<String, dynamic> map) {
    return InCatModel(
        id: map['id'], name: map['name'], des: map['description'] ?? '');
  }
}
