class UsersModel {
  final String id;
  final String email;
  final String? name;
  final String role;
  final String? access;

  UsersModel(
      {required this.id,
      required this.email,
      required this.name,
      this.access,
      required this.role});

  factory UsersModel.fromJson(Map<String, dynamic> map) {
    return UsersModel(
        id: map['id'],
        email: map['email'],
        name: map['name'] ?? '',
        access: map['access'],
        role: map['role']);
  }
}
