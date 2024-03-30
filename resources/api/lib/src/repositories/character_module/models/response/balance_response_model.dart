// ignore_for_file: avoid_dynamic_calls

import 'package:api/src/index.dart';

class BalanceResponseModel extends IBaseModel<BalanceResponseModel> {

  BalanceResponseModel({
    this.id,
    this.kod,
    this.firma,
    this.iskontoOrani,
    this.cariHesapTuru,
    this.aciklama,
    this.durum,
    this.balance,
    this.currencyBalance,
  });

  int? id;
  String? kod;
  String? firma;
  int? iskontoOrani;
  int? cariHesapTuru;
  String? aciklama;
  bool? durum;
  double? balance;
  double? currencyBalance;

  @override
  BalanceResponseModel fromJson(Map<String, dynamic> json) =>
      BalanceResponseModel(
        id: json['id'],
        kod: json['kod'],
        firma: json['firma'],
        iskontoOrani: json['iskontoOrani'],
        cariHesapTuru: json['cariHesapTuru'],
        aciklama: json['aciklama'],
        durum: json['durum'],
        balance: json['balance']?.toDouble(),
        currencyBalance: json['currencyBalance']?.toDouble(),
      );

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}
