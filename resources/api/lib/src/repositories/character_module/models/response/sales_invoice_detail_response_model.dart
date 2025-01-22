import 'package:api/api.dart';


class SalesInvoiceDetailResponseModel extends IBaseModel<SalesInvoiceDetailResponseModel> {

  SalesInvoiceDetailResponseModel({
    this.faturaBilgileri,
  });

  final List<SalesInvoiceDetailItemModel>? faturaBilgileri;
  
  @override
  SalesInvoiceDetailResponseModel fromJson(Map<String, dynamic> json) {
    return SalesInvoiceDetailResponseModel(
      faturaBilgileri: json['faturaBilgileri'] == null
          ? []
          : List<SalesInvoiceDetailItemModel>.from(
              json['faturaBilgileri']!
                  .map((x) => SalesInvoiceDetailItemModel().fromJson(x)),
            ),
    );
  }
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'faturaBilgileri': faturaBilgileri == null
          ? []
          : List<dynamic>.from(faturaBilgileri!.map((x) => x.toJson())),
    };
  }


}

class SalesInvoiceDetailItemModel extends IBaseModel<SalesInvoiceDetailItemModel> {

  SalesInvoiceDetailItemModel({
    this.id,
    this.satisFaturaId,
    this.urunId,
    this.alinanSiparisBilgileriId,
    this.miktar,
    this.birimFiyat,
    this.dovizliBirimFiyat,
    this.kdvHaricTutar,
    this.kdvOrani,
    this.kdvTutari,
    this.tutar,
    this.productName,
    this.code,
  });
  final int? id;
  final int? satisFaturaId;
  final int? urunId;
  final int? alinanSiparisBilgileriId;
  final double? miktar;
  final double? birimFiyat;
  final double? dovizliBirimFiyat;
  final double? kdvHaricTutar;
  final double? kdvOrani;
  final double? kdvTutari;
  final double? tutar;
  final String? productName;
  final String? code;
  
  @override
  SalesInvoiceDetailItemModel fromJson(Map<String, dynamic> json) {
    return SalesInvoiceDetailItemModel(
      id: json['id'],
      satisFaturaId: json['satisFaturaId'],
      urunId: json['urunId'],
      alinanSiparisBilgileriId: json['alinanSiparisBilgileriId'],
      miktar: json['miktar'],
      birimFiyat: json['birimFiyat'],
      dovizliBirimFiyat: json['dovizliBirimFiyat'],
      kdvHaricTutar: json['kdvHaricTutar'],
      kdvOrani: json['kdvOrani'],
      kdvTutari: json['kdvTutari'],
      tutar: json['tutar'],
      productName: json['productName'],
      code: json['code'],
    );
  }
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'satisFaturaId': satisFaturaId,
      'urunId': urunId,
      'alinanSiparisBilgileriId': alinanSiparisBilgileriId,
      'miktar': miktar,
      'birimFiyat': birimFiyat,
      'dovizliBirimFiyat': dovizliBirimFiyat,
      'kdvHaricTutar': kdvHaricTutar,
      'kdvOrani': kdvOrani,
      'kdvTutari': kdvTutari,
      'tutar': tutar,
      'productName': productName,
      'code': code,
    };
  }
}
