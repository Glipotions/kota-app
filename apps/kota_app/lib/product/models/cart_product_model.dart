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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'price': price,
      'quantity': quantity,
      'pictureUrl': pictureUrl,
    };
  }

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String?,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      pictureUrl: json['pictureUrl'] as String?,
    );
  }

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

class CartProductPdfModel {
  CartProductPdfModel({
    this.id,
    this.code,
    this.date,
    this.totalPrice,
    this.totalQuantity,
    this.items,
  });

  int? id;
  String? code;
  DateTime? date;
  double? totalPrice;
  int? totalQuantity;
  List<CartProductModel>? items;
}
