class ESCatModel {
  final String id;
  final String name;
  final String cat;

 ESCatModel({required this.id, required this.name, required this.cat});

  factory ESCatModel.fromJson(Map<String, dynamic> map) {
    return ESCatModel(id: map['id'], name: map['name'], cat: map['category']);
  }
}
