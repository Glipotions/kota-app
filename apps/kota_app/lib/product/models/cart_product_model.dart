class CartProductModel {
  CartProductModel({
    required this.id,
    required this.code,
    required this.price,
    required this.quantity,
    this.name,
    this.pictureUrl,
    this.sizeName,
    this.colorName,
    this.productCodeGroupId,
    this.orderDetailId,
    this.currencyUnitPrice,
  });

  int id;
  int? productCodeGroupId;
  String code;
  String? name;
  double price;
  double? currencyUnitPrice;
  int quantity;
  String? pictureUrl;
  String? sizeName;
  String? colorName;
  int? orderDetailId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'price': price,
      'quantity': quantity,
      'pictureUrl': pictureUrl,
      'sizeName': sizeName,
      'colorName': colorName,
      'productCodeGroupId': productCodeGroupId,
    };
  }

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String?,
      price: (json['price'] as num).toDouble(),
      currencyUnitPrice: (json['currencyUnitPrice'] as num).toDouble(),
      quantity: json['quantity'] as int,
      pictureUrl: json['pictureUrl'] as String?,
      sizeName: json['sizeName'] as String?,
      colorName: json['colorName'] as String?,
      productCodeGroupId: json['productCodeGroupId'] as int?,
      orderDetailId: json['orderDetailId'] as int?,
    );
  }

  CartProductModel copyWith({
    int? id,
    String? code,
    String? name,
    double? price,
    double? currencyUnitPrice,
    int? quantity,
    String? pictureUrl,
    String? sizeName,
    String? colorName,
    int? productCodeGroupId,
    int? orderDetailId,
  }) {
    return CartProductModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      price: price ?? this.price,
      currencyUnitPrice: currencyUnitPrice ?? this.currencyUnitPrice,
      quantity: quantity ?? this.quantity,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      sizeName: sizeName ?? this.sizeName,
      colorName: colorName ?? this.colorName,
      productCodeGroupId: productCodeGroupId ?? this.productCodeGroupId,
      orderDetailId: orderDetailId ?? this.orderDetailId,
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
    this.description,
  });

  int? id;
  String? code;
  DateTime? date;
  String? description;
  double? totalPrice;
  int? totalQuantity;
  List<CartProductModel>? items;
}
