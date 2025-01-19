// ignore_for_file: avoid_dynamic_calls, inference_failure_on_untyped_parameter

import 'package:api/src/index.dart';

class TransactionsHistoryResponseModel
    extends IBaseModel<TransactionsHistoryResponseModel> {
  TransactionsHistoryResponseModel({
    this.items,
    this.index,
    this.size,
    this.count,
    this.pages,
    this.hasPrevious,
    this.hasNext,
  });

  List<TransactionItem>? items;
  int? index;
  int? size;
  int? count;
  int? pages;
  bool? hasPrevious;
  bool? hasNext;

  @override
  TransactionsHistoryResponseModel fromJson(Map<String, dynamic> json) =>
      TransactionsHistoryResponseModel(
        items: json['items'] == null
            ? []
            : List<TransactionItem>.from(
                json['items']!.map((x) => TransactionItem().fromJson(x)),
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

class TransactionItem extends IBaseModel<TransactionItem> {
  TransactionItem({
    this.id,
    this.cariHesapId,
    this.tarih,
    this.fisNo,
    this.fisTuru,
    this.aciklama,
    this.borc,
    this.alacak,
    this.bakiye,
    this.dovizBorc,
    this.dovizAlacak,
    this.dovizBakiye,
  });

  double? id;
  int? cariHesapId;
  DateTime? tarih;
  String? fisNo;
  String? fisTuru;
  String? aciklama;
  double? borc;
  double? alacak;
  double? bakiye;
  double? dovizBorc;
  double? dovizAlacak;
  double? dovizBakiye;

  @override
  TransactionItem fromJson(Map<String, dynamic> json) => TransactionItem(
        id: json['id']?.toDouble(),
        cariHesapId: json['cariHesapId'],
        tarih: json['tarih'] == null ? null : DateTime.parse(json['tarih']),
        fisNo: json['fisNo'],
        fisTuru: json['fisTuru'],
        aciklama: json['aciklama'],
        borc: json['borc']?.toDouble(),
        alacak: json['alacak']?.toDouble(),
        bakiye: json['bakiye']?.toDouble(),
        dovizBorc: json['dovizBorc']?.toDouble(),
        dovizAlacak: json['dovizAlacak']?.toDouble(),
        dovizBakiye: json['dovizBakiye']?.toDouble(),
      );

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}
