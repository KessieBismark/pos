class BranchModel {
  final String id;
  final String name;

  BranchModel({required this.id, required this.name});

  factory BranchModel.fromJson(Map<String, dynamic> map) {
    return BranchModel(id: map['id'], name: map['name']);
  }
}
