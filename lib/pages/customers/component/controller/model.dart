class CustomerModel {
  final String id;
  final String name;
  final String? email;
  final String? contact;
  final String? address;
  final dynamic discount;

  CustomerModel({
    required this.id,
    required this.name,
    this.email,
    this.contact,
    this.address,
    required this.discount,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'],
      name: map['name'],
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      contact: map['contact'] ?? '',
      discount: map['discount'],
    );
  }
}
