class InSCatModel {
  final String id;
  final String name;
  final String cat;

 InSCatModel({required this.id, required this.name, required this.cat});

  factory InSCatModel.fromJson(Map<String, dynamic> map) {
    return InSCatModel(id: map['id'], name: map['name'], cat: map['category']);
  }
}
