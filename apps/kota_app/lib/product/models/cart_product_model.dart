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
    this.discountRate = 0,
    this.remainingQuantity,
    this.mainProductCode, // Main product code for API calls
  });

  int id;
  int? productCodeGroupId;
  String code;
  String? name;
  double price;
  double? currencyUnitPrice;
  int quantity;
  int? remainingQuantity; // Kalan miktar
  String? pictureUrl;
  String? sizeName;
  String? colorName;
  int? orderDetailId;
  double discountRate; // Discount rate as percentage (0-100)
  String? mainProductCode; // Main product code for navigation to product detail

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'price': price,
      'currencyUnitPrice': currencyUnitPrice,
      'quantity': quantity,
      'remainingQuantity': remainingQuantity,
      'pictureUrl': pictureUrl,
      'sizeName': sizeName,
      'colorName': colorName,
      'productCodeGroupId': productCodeGroupId,
      'discountRate': discountRate,
      'mainProductCode': mainProductCode,
    };
  }

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String?,
      price: (json['price'] as num).toDouble(),
      currencyUnitPrice: json['currencyUnitPrice'] != null
          ? (json['currencyUnitPrice'] as num).toDouble()
          : null,
      quantity: json['quantity'] as int,
      remainingQuantity: json['remainingQuantity'] as int?,
      pictureUrl: json['pictureUrl'] as String?,
      sizeName: json['sizeName'] as String?,
      colorName: json['colorName'] as String?,
      productCodeGroupId: json['productCodeGroupId'] as int?,
      orderDetailId: json['orderDetailId'] as int?,
      discountRate: json['discountRate'] != null
          ? (json['discountRate'] as num).toDouble()
          : 0,
      mainProductCode: json['mainProductCode'] as String?,
    );
  }

  CartProductModel copyWith({
    int? id,
    String? code,
    String? name,
    double? price,
    double? currencyUnitPrice,
    int? quantity,
    int? remainingQuantity,
    String? pictureUrl,
    String? sizeName,
    String? colorName,
    int? productCodeGroupId,
    int? orderDetailId,
    double? discountRate,
    String? mainProductCode,
  }) {
    return CartProductModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      price: price ?? this.price,
      currencyUnitPrice: currencyUnitPrice ?? this.currencyUnitPrice,
      quantity: quantity ?? this.quantity,
      remainingQuantity: remainingQuantity ?? this.remainingQuantity,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      sizeName: sizeName ?? this.sizeName,
      colorName: colorName ?? this.colorName,
      productCodeGroupId: productCodeGroupId ?? this.productCodeGroupId,
      orderDetailId: orderDetailId ?? this.orderDetailId,
      discountRate: discountRate ?? this.discountRate,
      mainProductCode: mainProductCode ?? this.mainProductCode,
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
