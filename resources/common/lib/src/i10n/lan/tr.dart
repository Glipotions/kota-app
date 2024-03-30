import 'package:common/src/i10n/default_localization.dart';

///Localization File For Turkish - TR
class TrLocalization extends AppLocalizationLabel {
  @override
  final String lanCode = 'tr';
  @override
  final String localizationTitle = 'Türkçe';
  @override
  final String defaultErrorMessage =
      'Hata oluştu. Lütfen daha sonra tekrar deneyiniz';
  @override
  final String noInternetErrorMessage =
      'Lütfen internet bağlantınızı kontrol ediniz.';
  @override
  final String unauthorizedErrorMessage =
      'Bu işlem için yetkiniz bulunmamaktadır.';
  @override
  final String serverErrorMessage =
      'Sunucu kaynaklı bi hata oluştu. Lütfen daha sonra tekrar deneyiniz';
  @override
  final String cancelBtnText = 'İptal';
  @override
  final String tryAgainBtnText = 'Tekrar Dene';

  @override
  String get timeoutErrorMessage => 'Bağlantı zaman aşımına uğradı';

  @override
  String get unknownPageRouteMessageText => 'Burada olmaman gerek :)';

  @override
  String get eMail => 'E-Mail';

  @override
  String get login => 'Giriş Yap';

  @override
  String get loginToYourAccount => 'Hesabınıza Giriş Yapın';

  @override
  String get password => 'Şifre';

  @override
  String get welcomeBack => 'Hoşgeldiniz';

  @override
  String get dashboard => 'Panel';

  @override
  String get document => 'Doküman';

  @override
  String get task => 'Görevler';

  @override
  String get transaction => 'İşlemler';

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String atLeastLenghtText(int desiredLenght) =>
      'Lütfen en az $desiredLenght giriniz.';

  @override
  String get invalidCreditCardCvvText => 'Lütfen geçerli bir CVV giriniz.';

  @override
  String get invalidCreditCardDateText =>
      'Lütfen geçerli bir kart tarihi giriniz.';

  @override
  String get invalidCreditCardNumberText =>
      'Lütfen geçerli bir kart numarası giriniz.';

  @override
  String get invalidMailText => 'Lütfen geçerli bir mail giriniz.';

  @override
  String get invalidNameText => 'Lütfen geçerli bir isim giriniz.';

  @override
  String get requiredText => 'Bu alan zorunludur.';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get succesfullyLoggedIn => 'Başarı ile giriş yapıldı.';
  
  @override
  String get succesfullyLoggedOut => 'Başarı ile çıkış yapıldı.';
}
