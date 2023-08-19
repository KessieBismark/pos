class CartModel {
  final String serviceId;
  final String service;
  final String sub;
  final String? cat;
    int quantity;
  final dynamic price;

  CartModel(
      {required this.service,
      required this.sub,
      this.cat,
       this.quantity = 0,
      required this.price,
     required this.serviceId});
}

class OrderModel {

  final String product;
  final int quantity;
  final String category;

  OrderModel({
    required this.product,
    required this.quantity,
    required this.category,
  });
}
