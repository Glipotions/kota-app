// ignore_for_file: avoid_dynamic_calls, inference_failure_on_untyped_parameter

import 'dart:convert';
import 'package:api/src/index.dart';

class ActiveOrdersResponseModel extends IBaseModel<ActiveOrdersResponseModel> {
  ActiveOrdersResponseModel({
    this.items,
  });

  List<AlinanSiparisBilgileriL>? items;

  @override
  dynamic jsonParser(String jsonBody) {
    final newJson = jsonDecode(jsonBody);

    // API yanıtı tek bir nesne olarak geliyorsa
    if (newJson is Map<String, dynamic> && newJson.containsKey('urunKodu')) {
      final item = AlinanSiparisBilgileriL().fromJson(newJson);
      return ActiveOrdersResponseModel(items: [item]);
    }

    // API yanıtı bir liste olarak geliyorsa
    if (newJson is List) {
      final items = newJson.map((e) =>
        AlinanSiparisBilgileriL().fromJson(e as Map<String, dynamic>),
      ).toList();
      return ActiveOrdersResponseModel(items: items);
    }

    // Standart işleme devam et
    return super.jsonParser(jsonBody);
  }

  @override
  ActiveOrdersResponseModel fromJson(dynamic json) {
    // API yanıtı tek bir nesne olarak geliyorsa
    if (json is Map<String, dynamic> && json.containsKey('urunKodu')) {
      // Tek bir nesneyi bir listeye dönüştür
      final item = AlinanSiparisBilgileriL().fromJson(json);
      return ActiveOrdersResponseModel(items: [item]);
    }

    // API yanıtı bir liste olarak geliyorsa
    if (json is List) {
      return ActiveOrdersResponseModel(
        items: List<AlinanSiparisBilgileriL>.from(
          json.map(
            (x) => AlinanSiparisBilgileriL().fromJson(x),
          ),
        ),
      );
    }

    // Eğer bir Map ise ve items alanı varsa
    if (json is Map<String, dynamic> && json.containsKey('items')) {
      return ActiveOrdersResponseModel(
        items: json['items'] == null
            ? []
            : List<AlinanSiparisBilgileriL>.from(
                json['items']!.map(
                  (x) => AlinanSiparisBilgileriL().fromJson(x),
                ),
              ),
      );
    }

    // Diğer durumlar için boş bir model döndür
    return ActiveOrdersResponseModel(items: []);
  }

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}

class AlinanSiparisBilgileriL extends IBaseModel<AlinanSiparisBilgileriL> {
  AlinanSiparisBilgileriL({
    this.id,
    this.urunId,
    this.alinanSiparisId,
    this.urunAdi,
    this.urunKodu,
    this.tutar,
    this.miktar,
    this.birimFiyat,
    this.kdvTutari,
    this.kdvOrani,
    this.kdvHaricTutar,
    this.dovizTuru,
    this.dovizliBirimFiyat,
    this.iskontoOrani,
    this.tarih,
    this.durum,
    this.faturadanKalanAdet,
    this.kalanAdet,
    this.iskontoTutari,
    this.netDovizTutar,
    // this.insert,
    // this.update,
    // this.delete,
    // this.alinanSiparis,
    // this.urun,
    // this.urunBilgileri,
    // this.hazirlananSiparisBilgileri,
  });

  int? id;
  int? urunId;
  int? alinanSiparisId;
  String? urunAdi;
  String? urunKodu;
  double? tutar;
  int? miktar;
  double? birimFiyat;
  double? kdvTutari;
  double? kdvOrani;
  double? kdvHaricTutar;
  int? dovizTuru;
  double? dovizliBirimFiyat;
  double? iskontoOrani;
  DateTime? tarih;
  bool? durum;
  double? faturadanKalanAdet;
  int? kalanAdet;
  double? iskontoTutari;
  double? netDovizTutar;
  // bool? insert;
  // bool? update;
  // bool? delete;
  // dynamic alinanSiparis;
  // dynamic urun;
  // List<dynamic>? urunBilgileri;
  // List<dynamic>? hazirlananSiparisBilgileri;

  @override
  AlinanSiparisBilgileriL fromJson(Map<String, dynamic> json) =>
      AlinanSiparisBilgileriL(
        id: json['id'],
        urunId: json['urunId'],
        alinanSiparisId: json['alinanSiparisId'],
        urunAdi: json['urunAdi'],
        urunKodu: json['urunKodu'],
        tutar: json['tutar']?.toDouble(),
        miktar: json['miktar'],
        birimFiyat: json['birimFiyat']?.toDouble(),
        kdvTutari: json['kdvTutari']?.toDouble(),
        kdvOrani: json['kdvOrani']?.toDouble(),
        kdvHaricTutar: json['kdvHaricTutar']?.toDouble(),
        dovizTuru: json['dovizTuru'],
        dovizliBirimFiyat: json['dovizliBirimFiyat']?.toDouble(),
        iskontoOrani: json['iskontoOrani']?.toDouble(),
        tarih: json['tarih'] == null ? null : DateTime.parse(json['tarih']),
        durum: json['durum'],
        faturadanKalanAdet: json['faturadanKalanAdet']?.toDouble(),
        kalanAdet: json['kalanAdet'],
        iskontoTutari: json['iskontoTutari']?.toDouble(),
        netDovizTutar: json['netDovizTutar']?.toDouble(),
        // insert: json['insert'],
        // update: json['update'],
        // delete: json['delete'],
        // alinanSiparis: json['alinanSiparis'],
        // urun: json['urun'],
        // urunBilgileri: json['urunBilgileri'] == null
        //     ? []
        //     : List<dynamic>.from(json['urunBilgileri']),
        // hazirlananSiparisBilgileri: json['hazirlananSiparisBilgileri'] == null
        //     ? []
        //     : List<dynamic>.from(json['hazirlananSiparisBilgileri']),
      );

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}
