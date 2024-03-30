// ignore_for_file: avoid_dynamic_calls

import 'package:api/api.dart';

class CreateOrderResponseModel extends IBaseModel<CreateOrderResponseModel> {
  CreateOrderResponseModel({
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

  @override
  CreateOrderResponseModel fromJson(Map<String, dynamic> json) =>
      CreateOrderResponseModel(
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
      );

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}
