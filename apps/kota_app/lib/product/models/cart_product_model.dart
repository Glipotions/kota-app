class CartProductModel {
  CartProductModel({
    required this.id,
    required this.code,
    required this.price,
    required this.quantity,
    this.name,
    this.pictureUrl,
  });

  int id;
  String code;
  String? name;
  double price;
  int quantity;
  String? pictureUrl;

  CartProductModel copyWith({
    int? id,
    String? code,
    String? name,
    double? price,
    int? quantity,
    String? pictureUrl,
  }) {
    return CartProductModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      pictureUrl: pictureUrl ?? this.pictureUrl,
    );
  }
}
