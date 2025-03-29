import 'package:api/api.dart';


class SalesInvoiceDetailResponseModel extends IBaseModel<SalesInvoiceDetailResponseModel> {

  SalesInvoiceDetailResponseModel({
    this.id,
    this.kod,
    this.cariHesapId,
    this.cariHesapAdi,
    this.depoId,
    this.ozelKod1Id,
    this.faturaTuru,
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
    this.faturaKdvOrani,
    this.odemeTipi,
    this.aciklama,
    this.durum,
    this.iskontoTutari2,
    this.iskontoOrani2,
    this.isDovizFatura,
    this.faturaBilgileri,
  });

  final int? id;
  final String? kod;
  final int? cariHesapId;
  final String? cariHesapAdi;
  final int? depoId;
  final int? ozelKod1Id;
  final int? faturaTuru;
  final int? dovizTuru;
  final double? dovizKuru;
  final String? tarih;
  final int? kdvSekli;
  final double? kdvHaricTutar;
  final double? iskontoTutari;
  final double? kdvTutari;
  final double? toplamTutar;
  final String? tutarYazi;
  final double? dovizTutar;
  final double? iskontoOrani;
  final double? faturaKdvOrani;
  final int? odemeTipi;
  final String? aciklama;
  final bool? durum;
  final double? iskontoTutari2;
  final double? iskontoOrani2;
  final bool? isDovizFatura;
  final List<SalesInvoiceDetailItemModel>? faturaBilgileri;
  
  @override
  SalesInvoiceDetailResponseModel fromJson(Map<String, dynamic> json) {
    return SalesInvoiceDetailResponseModel(
      id: json['id'],
      kod: json['kod'],
      cariHesapId: json['cariHesapId'],
      cariHesapAdi: json['cariHesapAdi'],
      depoId: json['depoId'],
      ozelKod1Id: json['ozelKod1Id'],
      faturaTuru: json['faturaTuru'],
      dovizTuru: json['dovizTuru'],
      dovizKuru: json['dovizKuru'],
      tarih: json['tarih'],
      kdvSekli: json['kdvSekli'],
      kdvHaricTutar: json['kdvHaricTutar'],
      iskontoTutari: json['iskontoTutari'],
      kdvTutari: json['kdvTutari'],
      toplamTutar: json['toplamTutar'],
      tutarYazi: json['tutarYazi'],
      dovizTutar: json['dovizTutar'],
      iskontoOrani: json['iskontoOrani'],
      faturaKdvOrani: json['faturaKdvOrani'],
      odemeTipi: json['odemeTipi'],
      aciklama: json['aciklama'],
      durum: json['durum'],
      iskontoTutari2: json['iskontoTutari2'],
      iskontoOrani2: json['iskontoOrani2'],
      isDovizFatura: json['isDovizFatura'],
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
      'id': id,
      'kod': kod,
      'cariHesapId': cariHesapId,
      'cariHesapAdi': cariHesapAdi,
      'depoId': depoId,
      'ozelKod1Id': ozelKod1Id,
      'faturaTuru': faturaTuru,
      'dovizTuru': dovizTuru,
      'dovizKuru': dovizKuru,
      'tarih': tarih,
      'kdvSekli': kdvSekli,
      'kdvHaricTutar': kdvHaricTutar,
      'iskontoTutari': iskontoTutari,
      'kdvTutari': kdvTutari,
      'toplamTutar': toplamTutar,
      'tutarYazi': tutarYazi,
      'dovizTutar': dovizTutar,
      'iskontoOrani': iskontoOrani,
      'faturaKdvOrani': faturaKdvOrani,
      'odemeTipi': odemeTipi,
      'aciklama': aciklama,
      'durum': durum,
      'iskontoTutari2': iskontoTutari2,
      'iskontoOrani2': iskontoOrani2,
      'isDovizFatura': isDovizFatura,
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
      miktar: json['miktar']?.toDouble(),
      birimFiyat: json['birimFiyat']?.toDouble(),
      dovizliBirimFiyat: json['dovizliBirimFiyat']?.toDouble(),
      kdvHaricTutar: json['kdvHaricTutar']?.toDouble(),
      kdvOrani: json['kdvOrani']?.toDouble(),
      kdvTutari: json['kdvTutari']?.toDouble(),
      tutar: json['tutar']?.toDouble(),
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
