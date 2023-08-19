class ECatModel {
  final String id;
  final String name;
  final String? des;

  ECatModel({required this.id, required this.name, this.des});

  factory ECatModel.fromJson(Map<String, dynamic> map) {
    return ECatModel(
        id: map['id'], name: map['name'], des: map['description'] ?? '');
  }
}
