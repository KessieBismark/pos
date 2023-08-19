class SSCatModel {
  final String id;
  final String name;
  final String cat;

  SSCatModel({required this.id, required this.name, required this.cat});

  factory SSCatModel.fromJson(Map<String, dynamic> map) {
    return SSCatModel(id: map['id'], name: map['name'], cat: map['category']);
  }
}
