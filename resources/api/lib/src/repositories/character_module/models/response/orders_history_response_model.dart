// ignore_for_file: avoid_dynamic_calls, inference_failure_on_untyped_parameter

import 'package:api/src/index.dart';

class OrdersHistoryResponseModel
    extends IBaseModel<OrdersHistoryResponseModel> {
  OrdersHistoryResponseModel({
    this.items,
    this.index,
    this.size,
    this.count,
    this.pages,
    this.hasPrevious,
    this.hasNext,
  });

  List<OrderItem>? items;
  int? index;
  int? size;
  int? count;
  int? pages;
  bool? hasPrevious;
  bool? hasNext;

  @override
  OrdersHistoryResponseModel fromJson(Map<String, dynamic> json) =>
      OrdersHistoryResponseModel(
        items: json['items'] == null
            ? []
            : List<OrderItem>.from(
                json['items']!.map((x) => OrderItem().fromJson(x)),
              ),
        index: json['index'],
        size: json['size'],
        count: json['count'],
        pages: json['pages'],
        hasPrevious: json['hasPrevious'],
        hasNext: json['hasNext'],
      );

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}

class OrderItem extends IBaseModel<OrderItem> {
  OrderItem({
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
    this.canBeDeleted = false,
    this.isFaturalanmis = false,
    this.connectedBranchCurrentInfoId,
    this.connectedBranchCurrentInfoName,
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
  bool? canBeDeleted;
  bool? isFaturalanmis;
  int? connectedBranchCurrentInfoId;
  String? connectedBranchCurrentInfoName;

  @override
  OrderItem fromJson(Map<String, dynamic> json) => OrderItem(
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
        canBeDeleted: json['canBeDeleted'],
        isFaturalanmis: json['isFaturalanmis'],
        connectedBranchCurrentInfoId:
            json['connectedBranchCurrentInfoId'],
        connectedBranchCurrentInfoName:
            json['connectedBranchCurrentInfoName'],
      );

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
