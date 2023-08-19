class ServiceCatModel {
  final String id;
  final String name;
  final String? des;

  ServiceCatModel({required this.id, required this.name, this.des});

  factory ServiceCatModel.fromJson(Map<String, dynamic> map) {
    return ServiceCatModel(
        id: map['id'], name: map['name'], des: map['description'] ?? '');
  }
}
