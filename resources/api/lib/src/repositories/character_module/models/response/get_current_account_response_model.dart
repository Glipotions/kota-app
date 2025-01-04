import 'package:api/src/index.dart';

class GetCurrentAccountResponseModel
    extends IBaseModel<GetCurrentAccountResponseModel> {
  GetCurrentAccountResponseModel({
    this.items,
    this.index,
    this.size,
    this.count,
    this.pages,
    this.hasPrevious,
    this.hasNext,
  });

  List<GetCurrentAccount>? items;
  int? index;
  int? size;
  int? count;
  int? pages;
  bool? hasPrevious;
  bool? hasNext;

  @override
  GetCurrentAccountResponseModel fromJson(Map<String, dynamic> json) =>
      GetCurrentAccountResponseModel(
        items: json['items'] == null
            ? []
            : List<GetCurrentAccount>.from(
                json['items']!.map((x) => GetCurrentAccount().fromJson(x)),
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

class GetCurrentAccount extends IBaseModel<GetCurrentAccount> {
  GetCurrentAccount({
    this.id,
    this.kod,
    this.firma,
    this.sehir,
    this.iskontoOrani,
    this.cariHesapTuru,
    this.aciklama,
    this.durum,
    this.bakiye,
    this.dovizliBakiye,
  });

  int? id;
  String? kod;
  String? firma;
  String? sehir;
  int? iskontoOrani;
  int? cariHesapTuru;
  String? aciklama;
  bool? durum;
  double? bakiye;
  double? dovizliBakiye;

  Map<String, dynamic> toJson() => {
        'id': id,
        'kod': kod,
        'firma': firma,
        'sehir': sehir,
        'iskontoOrani': iskontoOrani,
        'cariHesapTuru': cariHesapTuru,
        'aciklama': aciklama,
        'durum': durum,
        'bakiye': bakiye,
        'dovizliBakiye': dovizliBakiye
      };

  @override
  GetCurrentAccount fromJson(Map<String, dynamic> json) => GetCurrentAccount(
        id: json['id'],
        kod: json['kod'],
        firma: json['firma'],
        sehir: json['sehir'],
        iskontoOrani: json['iskontoOrani'],
        cariHesapTuru: json['cariHesapTuru'],
        aciklama: json['aciklama'],
        durum: json['durum'],
        bakiye: json['bakiye'] ?? json['balance'],
        dovizliBakiye: json['dovizliBakiye'] ?? json['currencyBalance'],
      );

  List<GetCurrentAccount> fromJsonList(List<dynamic> jsonList) {
    // var parsed = json.decode(jsonList);
    return jsonList.map((dynamic json) => fromJson(json)).toList();
  }
}
