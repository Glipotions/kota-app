// ignore_for_file: avoid_dynamic_calls, inference_failure_on_untyped_parameter

import 'dart:math';

import 'package:api/src/index.dart';

class OrdersHistoryDetailResponseModel
    extends IBaseModel<OrdersHistoryDetailResponseModel> {
  OrdersHistoryDetailResponseModel({
    this.id,
    this.kod,
    this.cariHesapId,
    this.ozelKod1Id,
    this.dovizTuru,
    this.dovizKuru,
    this.tarih,
    this.kdvSekli,
    this.kdvHaricTutar,
    this.iskontoTutari,
    this.kdvTutari,
    this.toplamTutar,
    this.tutarYazi,
    this.dovizTutar,
    this.iskontoOrani,
    this.siparisKdvOrani,
    this.aciklama,
    this.durum,
    this.items,
  });
  int? id;
  String? kod;
  int? cariHesapId;
  int? ozelKod1Id;
  int? dovizTuru;
  double? dovizKuru;
  DateTime? tarih;
  int? kdvSekli;
  double? kdvHaricTutar;
  double? iskontoTutari;
  double? kdvTutari;
  double? toplamTutar;
  String? tutarYazi;
  double? dovizTutar;
  double? iskontoOrani;
  double? siparisKdvOrani;
  String? aciklama;
  bool? durum;
  List<OrdersHistoryDetailItem>? items;

  @override
  OrdersHistoryDetailResponseModel fromJson(Map<String, dynamic> json) =>
      OrdersHistoryDetailResponseModel(
        id: json['id'],
        kod: json['kod'],
        cariHesapId: json['cariHesapId'],
        ozelKod1Id: json['ozelKod1Id'],
        dovizTuru: json['dovizTuru'],
        dovizKuru: json['dovizKuru']?.toDouble(),
        tarih: json['tarih'] == null ? null : DateTime.parse(json['tarih']),
        kdvSekli: json['kdvSekli'],
        kdvHaricTutar: json['kdvHaricTutar']?.toDouble(),
        iskontoTutari: json['iskontoTutari']?.toDouble(),
        kdvTutari: json['kdvTutari']?.toDouble(),
        toplamTutar: json['toplamTutar']?.toDouble(),
        tutarYazi: json['tutarYazi'],
        dovizTutar: json['dovizTutar']?.toDouble(),
        iskontoOrani: json['iskontoOrani']?.toDouble(),
        siparisKdvOrani: json['siparisKdvOrani']?.toDouble(),
        aciklama: json['aciklama'],
        durum: json['durum'],
        items: json['items'] == null
            ? []
            : List<OrdersHistoryDetailItem>.from(
                json['items']!
                    .map((x) => OrdersHistoryDetailItem().fromJson(x)),
              ),
      );

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class OrdersHistoryDetailItem extends IBaseModel<OrdersHistoryDetailItem> {
  OrdersHistoryDetailItem(
      {this.id,
      this.alinanSiparisId,
      this.urunId,
      this.miktar,
      this.birimFiyat,
      this.dovizliBirimFiyat,
      this.kdvHaricTutar,
      this.kdvOrani,
      this.kdvTutari,
      this.tutar,
      this.durum,
      this.code,
      this.pictureUrl,
      this.name,
      this.sizeName,
      this.colorName,
      this.productCodeGroupId,
      });
  final int? id;
  final int? alinanSiparisId;
  final int? urunId;
  final int? miktar;
  final double? birimFiyat;
  final double? dovizliBirimFiyat;
  final double? kdvHaricTutar;
  final double? kdvOrani;
  final double? kdvTutari;
  final double? tutar;
  final bool? durum;
  final String? code;
  final String? pictureUrl;
  final String? name;
  final String? sizeName;
  final String? colorName;
  final int? productCodeGroupId;

  @override
  OrdersHistoryDetailItem fromJson(Map<String, dynamic> json) {
    return OrdersHistoryDetailItem(
      id: json['id'],
      alinanSiparisId: json['alinanSiparisId'],
      urunId: json['urunId'],
      miktar: json['miktar'],
      birimFiyat: json['birimFiyat'],
      dovizliBirimFiyat: json['dovizliBirimFiyat'],
      kdvHaricTutar: json['kdvHaricTutar'],
      kdvOrani: json['kdvOrani'],
      kdvTutari: json['kdvTutari'],
      tutar: json['tutar'],
      durum: json['durum'],
      code: json['code'],
      pictureUrl: json['pictureUrl'],
      name: json['name'],
      sizeName: json['sizeName'],
      colorName: json['colorName'],
      productCodeGroupId: json['productCodeGroupId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alinanSiparisId': alinanSiparisId,
      'urunId': urunId,
      'miktar': miktar,
      'birimFiyat': birimFiyat,
      'dovizliBirimFiyat': dovizliBirimFiyat,
      'kdvHaricTutar': kdvHaricTutar,
      'kdvOrani': kdvOrani,
      'kdvTutari': kdvTutari,
      'tutar': tutar,
      'durum': durum,
      'code': code,
      'pictureUrl': pictureUrl,
      'name': name,
      'sizeName': sizeName,
      'colorName': colorName,
      'productCodeGroupId': productCodeGroupId,
    };
  }
}
